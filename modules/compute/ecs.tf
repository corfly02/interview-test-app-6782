resource "aws_ecr_repository" "repository" {
  name                 = "${var.app_name}-project-repo"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_rule" {
  repository = aws_ecr_repository.repository.name

  policy = jsonencode({
    rules = [for rule in var.ecr_lifecycle_policy : {
      rulePriority = rule.rulePriority
      description  = rule.description
      selection    = rule.selection
      action       = rule.action
    }]
  })
}