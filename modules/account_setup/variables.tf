variable "tags" {
  type        = map(string)
  description = " A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  validation {
    condition     = length(lookup(var.tags, "t_AppID", "")) > 6 && length(lookup(var.tags, "t_environment", "")) >= 2 && (length(lookup(var.tags, "t_dcl", "")) == 1 || length(lookup(var.tags, "t_dcl", "")) == 4)
    error_message = "Tags must contain at least these non-empty keys: t_dcl, t_AppID, and t_environment."
  }
  validation {
    condition = contains([
      "PRD", "DEV", "QA", "TST", "PRF", "STG", "POC", "DR", "PPE", "SMK", "PV", "UAT", "INT", "ACP", "IVV", "NONPRD",
      "DEMO", "SEC", "BETA"
    ], lookup(var.tags, "t_environment"))
    error_message = "Tag t_environment must be one of the following: PRD, DEV, QA, TST, PRF, STG, POC, DR, PPE, SMK, PV, UAT, INT, ACP, IVV, NONPRD, DEMO, SEC, or BETA."
  }
  validation {
    condition     = contains(["1", "2", "3", "DCL1", "DCL2", "DCL3"], lookup(var.tags, "t_dcl"))
    error_message = "Tag t_dcl must be one of the following: 1, 2, 3, DCL1, DCL2, or DCL3."
  }
  validation {
    condition     = substr(lookup(var.tags, "t_AppID"), 0, 3) == "SVC"
    error_message = "Tag t_AppID must begin with SVC."
  }
}

variable "github_repos" {
  description = <<EOF
    Repository list where worfklow that will access this role live.
    This is to ensure that only that repo has access to this role.
    Example:
    [
      "repo:pearson-highereducation/some-repo:*",
      "repo:pearson-otherorg/some-other-repo:*"
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
