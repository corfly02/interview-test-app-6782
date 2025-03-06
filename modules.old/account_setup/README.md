# account_setup

<!-- BEGIN_TF_DOCS -->

## Terraform Module for creating OIDC IDP and IAM Role for GitHub actions workflows to assume

This terraform module creates an OIDC Identity Provider and IAM role inside the target account that allows GitHub actions to assume that role inside the workflow.

## Trust policy

The trust policy can be a little confusing, so the regex is the following. The `repo:x` is what you need to enter in your terraform variables:

`"repo:<org>/<repo>:<branch/*>"`

- You can use `"repo:sample_org/*"` to assume the role from any repository in the GitHub org.
- You can use `"repo:sample_org/sample_repo:*"` to allow access from any branch in sample\_repo inside sample\_org to assume the role.
- You can use `"repo:sample_org/sample_repo:ref:refs/heads/main"` to allow access from the main branch in sample\_repo in sample\_org to assume the role.
- You can use `"repo:sample_org/sample_repo:ref:environment:prod"` to allow access from the production envirornment in sample\_repo in sample\_org to assume the role.

For more information regarding regex for the trust policy, please visit this link - https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws

## Least permissions by default

The IAM role that is created comes with no policies attached. This means you will need to assign any permissions you want the role to have in the format of `name = "<policy_arn>"`. eg `s3 = "arn:aws:iam::aws:policy/AmazonS3FullAccess"`.

## Sample workflow to assume the role

```yaml
name: Testing Docker

on: push

permissions:
  id-token: write # This is required for requesting the JWT
  contents: read  # This is required for actions/checkout

jobs:
  build:
    runs-on: interview-poc-runner-set-beta
    steps:
    - name: Check out the repository
      uses: actions/checkout@v3

    - name: Terraform init
      run: terraform init

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Build Docker image
      uses: docker/build-push-action@v3
      with:
        context: .
        file: Dockerfile
        load: true

    - name: Assume AWS Role via OIDC
      uses: aws-actions/configure-aws-credentials@v4
      with:
        role-to-assume: arn:aws:iam::674890471878:role/GitHubActionsRole
        aws-region: us-east-1

    - name: Test S3 access
      run: |
        aws s3 ls
```

#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.merged_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.app_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.app_bucket_ownership_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.app_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.app_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.github_repos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_repos"></a> [github\_repos](#input\_github\_repos) | Repository list where worfklow that will access this role live.<br/>    This is to ensure that only that repo has access to this role.<br/>    Example:<br/>    [<br/>      "repo:org/some-repo:*"<br/>    ] | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be abblied to all resources as default tags. | `map(string)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The default region you are deploying resources | `string` | `"us-east-1"` | no |
| <a name="input_role_policies"></a> [role\_policies](#input\_role\_policies) | IAM policies to be assigned to the role. Format is whatever\_name = arn\_of\_policy. | `map(string)` | `{}` | no |

#### Outputs

No outputs.

<!-- END_TF_DOCS -->
