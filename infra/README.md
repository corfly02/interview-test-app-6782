# infra

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.89.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_my_interview_app"></a> [my\_interview\_app](#module\_my\_interview\_app) | ./../modules/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_contact_email"></a> [alert\_contact\_email](#input\_alert\_contact\_email) | The email address to send alerts to. | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of your application. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region you are deploying to | `string` | `"us-east-1"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The container port and host port for your container | `number` | `5000` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The version of your ECR image | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be abblied to all resources as default tags. | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR of your VPC | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
