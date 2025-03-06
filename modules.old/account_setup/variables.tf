#global
variable "aws_region" {
  type        = string
  description = "The default region you are deploying resources"
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Tags that will be abblied to all resources as default tags."
}

#OIDC
variable "github_repos" {
  description = <<EOF
    Repository list where worfklow that will access this role live.
    This is to ensure that only that repo has access to this role.
    Example:
    [
      "repo:org/some-repo:*"
    ]
  EOF
  type        = list(string)
  validation {
    condition     = length([for s in var.github_repos : substr(s, 0, 5) == "repo:" if substr(s, 0, 5) == "repo:"]) == length(var.github_repos)
    error_message = "All repos must start with 'repo:'"
  }
}

variable "role_policies" {
  description = "IAM policies to be assigned to the role. Format is whatever_name = arn_of_policy."
  type        = map(string)
  default     = {}
}
