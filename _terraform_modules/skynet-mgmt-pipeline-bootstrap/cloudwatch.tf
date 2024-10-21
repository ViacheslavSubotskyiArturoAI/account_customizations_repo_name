resource "aws_cloudwatch_log_group" "codebuild" {
  for_each = local.codebuild_project

  name              = "/aws/codebuild/${each.value}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
}
