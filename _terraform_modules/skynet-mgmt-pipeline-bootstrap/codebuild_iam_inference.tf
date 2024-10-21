data "aws_iam_policy_document" "codebuild_skynet_inference_assume_role_policy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild_skynet_inference_role" {
  name               = "${local.codebuild_inference_prefix}-service-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_skynet_inference_assume_role_policy.json
}
