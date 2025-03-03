provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = var.app_name
  cidr = var.vpc_cidr

  azs                 = local.azs
  private_subnets     = var.private_subnets
  private_subnet_tags = merge(var.tags, { type = "private" })
  public_subnets      = var.public_subnets

  public_subnet_names  = [for i in range(0, 3) : "$(var.app_name)-public-${element(data.aws_availability_zones.available.names, i)}"]
  private_subnet_names = [for i in range(0, 3) : "$(var.app_name)-private-${element(data.aws_availability_zones.available.names, i)}"]

  enable_nat_gateway = var.enable_nat_gateway

  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60
  flow_log_destination_type            = "s3"
  flow_log_destination_arn             = var.enable_flow_log ? var.flow_log_destination_arn : null
}