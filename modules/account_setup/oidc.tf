provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["D89E3BD43D5D909B47A18977AA9D5CE36CEE184C"]
}

data "aws_iam_policy_document" "github_repos" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity",
      "sts:TagSession"
    ]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "${aws_iam_openid_connect_provider.github.url}:sub"
      values   = var.github_repos
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "GitHubActionsRole"
  assume_role_policy = data.aws_iam_policy_document.github_repos.json
}

resource "aws_iam_role_policy_attachment" "merged_policies" {
  for_each   = var.role_policies
  role       = aws_iam_role.github_actions.name
  policy_arn = each.value
}
