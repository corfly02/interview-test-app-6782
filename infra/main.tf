terraform {
  backend "s3" {}
}

module "vpc_stack" {
  source = "../modules/network/"

  app_name                 = var.app_name
  vpc_cidr                 = var.vpc_cidr
  private_subnets          = var.private_subnets
  public_subnets           = var.public_subnets
  flow_log_destination_arn = var.flow_log_destination_arn

  tags = merge(var.tags, var.app_name)
}

module "service_stack" {
  source = "../modules/compute"

  app_name            = var.app_name
  cluster_name        = format("%s-%s", var.app_name, lookup(var.tags, "environment"))
  bucket_name         = format("%s-%s", var.app_name, data.aws_caller_identity.current)
  vpc_id              = module.vpc_stack.vpc.id
  alert_contact_email = "corfly02@gmail.com"

  tags = merge(var.tags, var.app_name)
}
