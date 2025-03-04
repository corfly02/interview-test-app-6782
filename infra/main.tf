terraform {
  backend "s3" {}
}

module "catImageVpc" {
  source = "../modules/network/*"

  app_name = var.app_name

  cidr            = var.cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags = merge(var.tags, var.app_name)
}

module "catEcr" {
  source = "../modules/compute/*"

  app_name     = var.app_name
  scan_on_push = var.scan_on_push
  bucket_name  = format("%s-%s-%s", var.app_name, data.aws_caller_identity.current)

  tags = merge(var.tags, var.app_name)
}
