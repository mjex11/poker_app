terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }

#   backend "s3" {
#     bucket         = "one-terraform-remote-state-s3"
#     region         = "ap-northeast-1"
#     profile        = "default"
#     key            = "terraform.tfstate"
#     encrypt        = true
#     dynamodb_table = "one-terraform-remote-state-dynamodb"
#   }
}

provider "aws" {
  region = "ap-northeast-1"
}


# resource "aws_kms_key" "this" {
#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10
# }

# resource "aws_s3_bucket" "this" {
#   bucket = "one-terraform-remote-state-s3"
# }

# resource "aws_s3_bucket_versioning" "this" {
#   bucket = aws_s3_bucket.this.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
#   bucket = aws_s3_bucket.this.id
#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.this.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

# resource "aws_dynamodb_table" "this" {
#   name           = "one-terraform-remote-state-dynamodb"
#   read_capacity  = 1
#   write_capacity = 1
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
