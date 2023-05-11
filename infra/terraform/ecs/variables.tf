variable "aws_region" {
  type        = string
  description = "The region in which to create and manage resources"
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  default = "10.100.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "the name of availability zones to use subnets"
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "public_subnets" {
  type        = list(string)
  description = "the CIDR blocks to create public subnets"
  default     = ["10.100.10.0/24", "10.100.20.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "the CIDR blocks to create private subnets"
  default     = ["10.100.30.0/24", "10.100.40.0/24"]
}