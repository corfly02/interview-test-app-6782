## Terraform Module for creating OIDC IDP and IAM Role for GitHub actions workflows to assume

This terraform module creates an OIDC Identity Provider and IAM role inside the target account that allows GitHub actions to assume that role inside the workflow.

## Trust policy 

The trust policy can be a little confusing, so the regex is the following. The `repo:x` is what you need to enter in your terraform variables:

`"repo:<org>/<repo>:<branch/*>"`

- You can use `"repo:sample_org/*"` to assume the role from any repository in the GitHub org.
- You can use `"repo:sample_org/sample_repo:*"` to allow access from any branch in sample_repo inside sample_org to assume the role.
- You can use `"repo:sample_org/sample_repo:ref:refs/heads/main"` to allow access from the main branch in sample_repo in sample_org to assume the role.
- You can use `"repo:sample_org/sample_repo:ref:environment:prod"` to allow access from the production envirornment in sample_repo in sample_org to assume the role.

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