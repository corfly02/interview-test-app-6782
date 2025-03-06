provider "aws" {}

run "s3_validation" {
  command = plan

  module {
    source = "./tests/setup_s3"
  }

  variables {
    app_name = "test-validation"
    aws_region = "us-east-1"
      tags = {
      Owner       = "Corey"
      environment = "test"
    }
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.app_bucket_access.block_public_acls == true
    error_message = "S3 bucket allows public ACLs!"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.app_bucket_access.block_public_policy == true
    error_message = "S3 bucket allows public policies!"
  }
}