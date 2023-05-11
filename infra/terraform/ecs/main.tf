locals {
  region = "ap-northeast-1"
  prefix = "one-ecs"
  tags = {
    Project   = local.prefix
    ManagedBy = "Terraform"
  }
  vpc_cidr = var.vpc_cidr

  ecr_repository_name = "${local.prefix}-ecr"

  container_name = "one-ecs"
  container_port = 3000
}

################################################################################
# Cluster
################################################################################

module "ecs_cluster" {
  source = "./modules/cluster"

  cluster_name = "${local.prefix}-cluster"

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 2
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = local.tags
}

################################################################################
# Service
################################################################################

data "aws_ecr_image" "ecr_image_newest" {
  repository_name = local.ecr_repository_name
  most_recent       = true
}

locals {
  ecr_repository_newest_tags = data.aws_ecr_image.ecr_image_newest.image_tags
}

data "aws_ecr_repository" "one-ecs" {
  name = local.ecr_repository_name
}

module "ecs_service" {
  source = "./modules/service"

  name        = "${local.prefix}-service"
  cluster_arn = module.ecs_cluster.arn

  cpu    = 1024
  memory = 2048

  ignore_task_definition_changes = true

  # Container definition(s)
  container_definitions = {

    fluent-bit = {
      cpu       = 256
      memory    = 512
      essential = true
      image     = nonsensitive(data.aws_ssm_parameter.fluentbit.value)
      firelens_configuration = {
        type = "fluentbit"
      }
      memory_reservation = 50
      user               = "0"
    }

    (local.container_name) = {
      cpu       = 256
      memory    = 512
      essential = true
      image     = "${data.aws_ecr_repository.one-ecs.repository_url}:${local.ecr_repository_newest_tags[0]}"
      port_mappings = [
        {
          name          = local.container_name
          containerPort = local.container_port
          hostPort      = local.container_port
          protocol      = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false

      dependencies = [{
        containerName = "fluent-bit"
        condition     = "START"
      }]

      enable_cloudwatch_logging = false
      log_configuration = {
        logDriver = "awsfirelens"
        options = {
          Name                    = "firehose"
          region                  = local.region
          delivery_stream         = "my-stream"
          log-driver-buffer-limit = "2097152"
        }
      }
      memory_reservation = 100
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = local.container_port
        dns_name = local.container_name
      }
      port_name      = local.container_name
      discovery_name = local.container_name
    }
  }

  load_balancer = {
    service = {
      target_group_arn = element(module.alb.target_group_arns, 0)
      container_name   = local.container_name
      container_port   = local.container_port
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = local.container_port
      to_port                  = local.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb_sg.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

data "aws_ssm_parameter" "fluentbit" {
  name = "/aws/service/aws-for-fluent-bit/stable"
}

resource "aws_service_discovery_http_namespace" "this" {
  name        = "${local.prefix}-service_discovery"
  description = "CloudMap namespace for ${local.prefix}"
  tags        = local.tags
}

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.prefix}-service"
  description = "Service security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = module.vpc.private_subnets_cidr_blocks

  tags = local.tags
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = "${local.prefix}-alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "${local.prefix}-${local.container_name}"
      backend_protocol = "HTTP"
      backend_port     = local.container_port
      target_type      = "ip"
    },
  ]

  tags = local.tags
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "${local.prefix}-vpc"
  cidr               = local.vpc_cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}
