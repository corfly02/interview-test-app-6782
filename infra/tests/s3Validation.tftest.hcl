run "validate_bucket_exists" {
  command = plan

  assert {
    condition = aws_s3_bucket.bucket.validate_bucket_exists
    error_message = "The S3 bucket does not exist"
  }
}

run "s3-bucket-public-access" {
  command = plan

  assert {
    condition = alltrue([
    data.aws_s3_bucket_public_access_block.bucket_access.block_public_acls,
    data.aws_s3_bucket_public_access_block.bucket_access.block_public_policy,
    data.aws_s3_bucket_public_access_block.bucket_access.ignore_public_acls,
    data.aws_s3_bucket_public_access_block.bucket_access.restrict_public_buckets
  ])
  error_message = "The S3 bucket allows public access. Ensure all public access settings are blocked."
  }
}