#Global
variable "app_name" {
  type        = string
  description = "The name of your application."
}

variable "tags" {
  type        = map(string)
  description = "Tags that will be abblied to all resources as default tags."
}

variable "aws_region" {
  type        = string
  description = "The AWS region that you wish to deploy to"
  default     = "us-east-1"
}

#VPC

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

variable "flow_log_destination_arn" {
  type        = string
  description = "The s3 bucket that you wish to put your VPC flow logs."
}


#Compute
