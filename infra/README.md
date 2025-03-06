# infra

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_my_interview_app"></a> [my\_interview\_app](#module\_my\_interview\_app) | ./../modules/ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_contact_email"></a> [alert\_contact\_email](#input\_alert\_contact\_email) | The email address to send alerts to. | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of your application. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region you are deploying to | `string` | `"us-east-1"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The container port and host port for your container | `number` | `8080` | no |
| <a name="input_image"></a> [image](#input\_image) | The arn of the image in ECR | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be abblied to all resources as default tags. | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR of your VPC | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
