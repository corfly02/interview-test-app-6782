variable "aws_region" {
  type        = string
  description = "The AWS region that you wish to deploy to"
  default     = "us-east-1"
}

variable "app_name" {
  type        = string
  description = "The name of your application"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR of your VPC"
}

variable "private_subnets" {
  type        = list(string)
  description = "The CIDRs of your private subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "The CIDRs of your public subnets"
}

