provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}
terraform {
  backend "s3" {}
}

module "my_interview_app" {
  source = "./../modules/"

  app_name       = var.app_name
  vpc_cidr       = var.vpc_cidr
  container_port = var.container_port

  tags = var.tags
}