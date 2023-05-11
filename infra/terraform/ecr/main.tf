
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
locals {
  region = "ap-northeast-1"
  prefix = "one-ecs"
  tags = {
    Project   = local.prefix
    ManagedBy = "Terraform"
  }
  ecr_repository_name = "${local.prefix}-ecr"
}


module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = local.ecr_repository_name
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  repository_image_scan_on_push = true

  tags = local.tags
}