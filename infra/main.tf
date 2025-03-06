provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}
terraform {
  backend "s3" {}
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "my_interview_app" {
  source = "./../modules/"

  app_name            = var.app_name
  vpc_cidr            = var.vpc_cidr
  container_port      = var.container_port
  image               = "${data.aws_caller_identity.current.id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${module.my_interview_app.aws_ecs_repository_name}:0.0.3"
  alert_contact_email = var.alert_contact_email

  tags = var.tags
}