# compute

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_metric_filter.error_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.log_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecr_lifecycle_policy.lifecycle_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.capacity_providers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_kms_key.my_cmk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.my_cmk_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_s3_bucket.app_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.app_bucket_ownership_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.app_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.app_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_service_discovery_http_namespace.ecs_namespaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace) | resource |
| [aws_service_discovery_private_dns_namespace.ecs_namespaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_sns_topic.error_log_alert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_contact_email"></a> [alert\_contact\_email](#input\_alert\_contact\_email) | The email address to send alerts to. | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of your application. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The default region you are deploying resources | `string` | `"us-east-1"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket. | `string` | n/a | yes |
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | The capacity providers associated with the cluster. | `list(string)` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ECS cluster name. | `string` | n/a | yes |
| <a name="input_container_insights_log_group_retention"></a> [container\_insights\_log\_group\_retention](#input\_container\_insights\_log\_group\_retention) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `1` | no |
| <a name="input_container_insights_settings"></a> [container\_insights\_settings](#input\_container\_insights\_settings) | The settings to use for container insights. | `string` | `null` | no |
| <a name="input_default_capacity_provider_strategy"></a> [default\_capacity\_provider\_strategy](#input\_default\_capacity\_provider\_strategy) | The default capacity provider strategy for the cluster. When services or tasks are run in the cluster with no launch type or capacity provider strategy specified, the default capacity provider strategy is used. | `map(number)` | `{}` | no |
| <a name="input_ecr_lifecycle_policy"></a> [ecr\_lifecycle\_policy](#input\_ecr\_lifecycle\_policy) | The required attributes for the ecr lifecycle policy. | <pre>map(object({<br/>    rulePriority = number<br/>    description  = string<br/>    selection = object({<br/>      tagStatus   = string<br/>      countType   = string<br/>      countUnit   = string<br/>      countNumber = number<br/>    })<br/>    action = object({<br/>      type = string<br/>    })<br/>  }))</pre> | <pre>{<br/>  "lifecycle_rule": {<br/>    "action": {<br/>      "type": "expire"<br/>    },<br/>    "description": "Expire images older than 14 days.",<br/>    "rulePriority": 1,<br/>    "selection": {<br/>      "countNumber": 14,<br/>      "countType": "sinceImagePushed",<br/>      "countUnit": "days",<br/>      "tagStatus": "untagged"<br/>    }<br/>  }<br/>}</pre> | no |
| <a name="input_ecs_cluster_discovery_namespace"></a> [ecs\_cluster\_discovery\_namespace](#input\_ecs\_cluster\_discovery\_namespace) | Name of the shared ECS namespace. | `string` | `""` | no |
| <a name="input_ecs_cluster_namespace"></a> [ecs\_cluster\_namespace](#input\_ecs\_cluster\_namespace) | Name of the shared ECS namespace. | `string` | `""` | no |
| <a name="input_ecs_discovery_namespaces"></a> [ecs\_discovery\_namespaces](#input\_ecs\_discovery\_namespaces) | Required parameters for ECS namespaces. | <pre>map(object({<br/>    name        = string<br/>    description = string<br/>  }))</pre> | `{}` | no |
| <a name="input_ecs_namespaces"></a> [ecs\_namespaces](#input\_ecs\_namespaces) | Required parameters for ECS namespaces. | <pre>map(object({<br/>    name        = string<br/>    description = string<br/>  }))</pre> | `{}` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | The tag mutability setting for the repo. | `string` | `"IMMUTABLE"` | no |
| <a name="input_namespace_arn"></a> [namespace\_arn](#input\_namespace\_arn) | The ARN of the default namespace to use for the cluster. | `string` | `""` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | The number of days to retain log events. | `number` | `30` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Indicates whether images are scanned after being pushed to the repo. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be abblied to all resources as default tags. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
