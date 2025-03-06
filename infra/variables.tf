#Global
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

#VPC

variable "vpc_cidr" {
  type        = string
  description = "The CIDR of your VPC"
}


#ECS
variable "container_port" {
  type        = number
  description = "The container port and host port for your container"
  default     = 8080
}

#Cloudwatch
variable "alert_contact_email" {
  type        = string
  description = "The email address to send alerts to."
}