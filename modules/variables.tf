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
  description = "The default region you are deploying resources"
  default     = "us-east-1"
}

#ALB
variable "enable_deletion_protection" {
  type        = bool
  description = "Enables deletion protection on ALB"
  default     = false
}

#VPC
variable "vpc_cidr" {
  type        = string
  description = "The CIDR for your VPC"
}

#ECS
variable "container_port" {
  type        = number
  description = "The container port and host port for your container"
}

#ecr
variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repo."
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Supplied values for this variable can only be \"MUTABLE\" or \"IMMUTABLE\"."
  }
}

variable "scan_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repo."
  default     = true
}

variable "ecr_lifecycle_policy" {
  description = "The required attributes for the ecr lifecycle policy."
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
      description  = "Expire images older than 14 days."
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