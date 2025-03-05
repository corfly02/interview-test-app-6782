provider "aws" {
  region = data.aws_region.current.name
  default_tags {
    tags = var.tags
  }
}
terraform {
  backend "s3" {}
}

data "aws_region" "current" {}

module "my_interview_app" {
  source = "../modules/"

  app_name       = var.app_name
  vpc_cidr       = var.vpc_cidr
  container_port = var.container_port
}

#S3
resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.app_name}-${data.aws_caller_identity.current.id}-artifact-bucket"
}

resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "app_bucket_access" {
  bucket                  = aws_s3_bucket.app_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "app_bucket_ownership_rule" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
