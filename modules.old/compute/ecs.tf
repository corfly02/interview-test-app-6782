locals {
  container_insights_settings = ["enhanced", "disabled", "enabled"]
  discovery_namespace_arn     = var.ecs_cluster_discovery_namespace != "" ? data.aws_service_discovery_dns_namespace.ecs_cluster_namespace[0].arn : var.ecs_cluster_discovery_namespace
  http_namespace_arn          = var.ecs_cluster_namespace != "" ? data.aws_service_discovery_http_namespace.ecs_cluster_namespace[0].arn : var.ecs_cluster_namespace
  namespace_arn               = local.discovery_namespace_arn != "" ? local.discovery_namespace_arn : local.http_namespace_arn
}
resource "aws_service_discovery_private_dns_namespace" "ecs_namespaces" {
  for_each = var.ecs_discovery_namespaces

  name        = each.value.name
  description = each.value.description
  vpc         = var.vpc_id
  tags        = var.tags
}

resource "aws_service_discovery_http_namespace" "ecs_namespaces" {
  for_each = var.ecs_namespaces

  name        = each.value.name
  description = each.value.description
  tags        = var.tags
}

resource "aws_ecs_cluster" "cluster" {
  depends_on = [
    aws_cloudwatch_log_group.log_group
  ]
  name = var.cluster_name

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = contains(local.container_insights_settings, var.container_insights_settings) ? var.container_insights_settings : "enabled"
  }

  dynamic "service_connect_defaults" {
    for_each = toset(length(var.namespace_arn) > 0 ? [1] : [])
    content {
      namespace = var.namespace_arn
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy

    content {
      base              = 1
      capacity_provider = default_capacity_provider_strategy.key
      weight            = default_capacity_provider_strategy.value
    }
  }
}
