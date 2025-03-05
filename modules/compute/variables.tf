#global
variable "app_name" {
  type        = string
  description = "The name of your application."
}

variable "tags" {
  type        = map(string)
  description = "Tags that will be abblied to all resources as default tags."
}

variable "aws_region" {
  type = string
  description = "The default region you are deploying resources"
  default = "us-east-1"
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

#ecs
variable "cluster_name" {
  type        = string
  description = "ECS cluster name."
}
variable "ecs_cluster_namespace" {
  type        = string
  default     = ""
  description = "Name of the shared ECS namespace."
}
variable "ecs_cluster_discovery_namespace" {
  type        = string
  default     = ""
  description = "Name of the shared ECS namespace."
}
variable "container_insights_log_group_retention" {
  type        = number
  default     = 1
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
}
variable "ecs_namespaces" {
  type = map(object({
    name        = string
    description = string
  }))
  default     = {}
  description = "Required parameters for ECS namespaces."
}
variable "ecs_discovery_namespaces" {
  type = map(object({
    name        = string
    description = string
  }))
  default     = {}
  description = "Required parameters for ECS namespaces."
}
variable "vpc_id" {
  type        = string
  description = "VPC ID."
}
variable "capacity_providers" {
  type        = list(string)
  description = "The capacity providers associated with the cluster."
  default     = null
}
variable "default_capacity_provider_strategy" {
  description = "The default capacity provider strategy for the cluster. When services or tasks are run in the cluster with no launch type or capacity provider strategy specified, the default capacity provider strategy is used."
  type        = map(number)
  default     = {}
}
variable "container_insights_log_group_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = 1
}
variable "container_insights_settings" {
  type        = string
  description = "The settings to use for container insights."
  default     = null
}
variable "namespace_arn" {
  type        = string
  description = "The ARN of the default namespace to use for the cluster."
  default     = ""
}

#s3
variable "bucket_name" {
  type        = string
  description = "The name of the bucket."
}

#cloudwatch
variable "retention_in_days" {
  type        = number
  description = "The number of days to retain log events."
  default     = 30
}

variable "alert_contact_email" {
  type        = string
  description = "The email address to send alerts to."
}
