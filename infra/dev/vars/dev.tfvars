app_name                 = "interview-app"
vpc_cidr                 = "10.0.0.0/24"
private_subnets          = "10.0.0.0/25"
public_subnets           = "10.0.0.128/25"
flow_log_destination_arn = ""

tags = {
    Owner       = "Corey"
    environment = "dev"
}