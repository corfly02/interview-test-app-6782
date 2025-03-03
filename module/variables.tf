variable "aws_region" {
  type = string
  description = "The AWS region that you wish to deploy to"
  default = "us-east-1"
}

variable "app_name" {
  type        = string
  description = "The name of your application"
}

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

variable "enable_nat_gateway" {
  type        = bool
  description = "The option to enable the creation of a nat gateway"
  default     = true
}

variable "enable_flow_log" {
  type = bool
  description = "The option to enable VPC flow logging"
  default = false
}

variable "flow_log_destination_arn" {
  type        = string
  description = "The s3 bucket that you wish to put your VPC flow logs"
}

variable "tags" {
  type = map(string)
  default = {
    "name" = "value"
  }
}

variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repo"
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Supplied values for this variable can only be \"MUTABLE\" or \"IMMUTABLE\"."
  }
}

variable "scan_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repo"
  default     = true
}

variable "ecr_lifecycle_policy" {
  type = map(object({
    rulePriority = number
    description  = string
    selection = object({
      tagStatus   = string
      countType   = string
      countUnit   = string
      countNumber = number
    })
    action = object({
      type = string
    })
  }))

  default = {
    "lifecycle_rule" = {
      rulePriority = 1
      description  = "Expire images older than 14 days"
      selection = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = 14
      }
      action = {
        type = "expire"
      }
    }
  }
}