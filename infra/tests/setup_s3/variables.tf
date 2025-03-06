variable "app_name" {
  type        = string
  description = "The name of your application."
}

variable "aws_region" {
  type        = string
  description = "The AWS region you are deploying to"
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Tags that will be abblied to all resources as default tags."
}