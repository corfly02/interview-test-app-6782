resource "aws_kms_key" "my_cmk" {
  description             = "my_cmk symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_key_policy" "my_cmk_policy" {
  key_id = aws_kms_key.my_cmk.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/ecs/containerinsights/${var.cluster_name}/performance"
  retention_in_days = var.retention_in_days
  kms_key_id        = aws_kms_key.my_cmk.arn
}

resource "aws_sns_topic" "error_log_alert" {
  name = "log-alert-topic"
}

resource "aws_ssm_parameter" "alert_contact_email" {
  name  = "alert-contact"
  type  = "String"
  value = var.alert_contact_email
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.error_log_alert.arn
  protocol  = "email"
  endpoint  = aws_ssm_parameter.alert_contact_email.value
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "log-error-filter"
  log_group_name = aws_cloudwatch_log_group.log_group.name

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
  alarm_actions       = [aws_sns_topic.log_alerts.arn]
}
