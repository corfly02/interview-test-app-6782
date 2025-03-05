#Global
variable "app_name" {
  type        = string
  description = "The name of your application."
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