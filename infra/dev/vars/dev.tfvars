app_name            = "interview-app"
vpc_cidr            = "10.0.0.0/16"
image               = "674890471878.dkr.ecr.us-east-1.amazonaws.com/interview-app-project-repo"
alert_contact_email = "ca8582@gmail.com"

tags = {
  Owner       = "Corey"
  environment = "dev"
}