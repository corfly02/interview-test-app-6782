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
  type = string
  description = "The default region you are deploying resources"
  default = "us-east-1"
}

#ALB
variable "enable_deletion_protection" {
  type = bool
  description = "Enables deletion protection on ALB"
  default = false
}

#VPC
variable "vpc_cidr" {
  type = string
  description = "The CIDR for your VPC"
}

#ECS
variable "container_port" {
  type = number
  description = "The container port and host port for your container"
}