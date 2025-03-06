data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

locals {
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)
  container_name = format("%s-%s-container", var.app_name, lookup(var.tags, "environment"))
}

#ECS Cluster
module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.12.0"

  cluster_name = format("%s-%s-cluster", var.app_name, lookup(var.tags, "environment"))

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
        base   = 1
      }
    }
  }
}

#ECS Service
module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.12.0"

  depends_on = [aws_ecr_repository.repository]

  name        = format("%s-%s-service", var.app_name, lookup(var.tags, "environment"))
  cluster_arn = module.ecs_cluster.arn

  cpu    = 1024
  memory = 4096

  enable_execute_command = true

  container_definitions = {

    (local.container_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = var.image
      port_mappings = [
        {
          name          = local.container_name
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false

      enable_cloudwatch_logging = true
      log_configuration = {
        logDriver = "awslogs"
      }

      memory_reservation = 100
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = var.container_port
        dns_name = local.container_name
      }
      port_name      = local.container_name
      discovery_name = local.container_name
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["interview_app"].arn
      container_name   = local.container_name
      container_port   = var.container_port
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = var.container_port
      to_port                  = var.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_service_discovery_http_namespace" "this" {
  name        = format("%s-%s-namespace", var.app_name, lookup(var.tags, "environment"))
  description = "CloudMap namespace for ${var.app_name}"
}

#Cloudwatch

resource "aws_sns_topic" "error_log_alert" {
  name = "log-alert-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.error_log_alert.arn
  protocol  = "email"
  endpoint  = var.alert_contact_email
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "log-error-filter"
  log_group_name = module.ecs_cluster.cloudwatch_log_group_name

  pattern = "ERROR"

  metric_transformation {
    name      = "ErrorCount"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "log_alarm" {
  alarm_name          = "HighErrorLogs"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Triggered when 'ERROR' appears more than 10 times in a minute"
  alarm_actions       = [aws_sns_topic.error_log_alert.arn]
}

#ALB
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = format("%s-%s-alb", var.app_name, lookup(var.tags, "environment"))

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = var.enable_deletion_protection

  #Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 5000
      to_port     = 5000
      ip_protocol = "tcp"
      cidr_ipv4   = "136.47.225.96/32"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    app_http = {
      port     = 5000
      protocol = "HTTP"

      forward = {
        target_group_key = "interview_app"
      }
    }
  }

  target_groups = {
    interview_app = {
      backend_protocol                  = "HTTP"
      backend_port                      = var.container_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      create_attachment = false
    }
  }
}

#VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = format("%s-%s-vpc", var.app_name, lookup(var.tags, "environment"))
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true
}

#ECR
resource "aws_ecr_repository" "repository" {
  name                 = "${var.app_name}-project-repo"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_rule" {
  repository = aws_ecr_repository.repository.name

  policy = jsonencode({
    rules = [for rule in var.ecr_lifecycle_policy : {
      rulePriority = rule.rulePriority
      description  = rule.description
      selection    = rule.selection
      action       = rule.action
    }]
  })
}

#S3
resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.app_name}-${data.aws_caller_identity.current.id}-artifact-bucket"
}

resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "app_bucket_access" {
  bucket                  = aws_s3_bucket.app_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "app_bucket_ownership_rule" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
