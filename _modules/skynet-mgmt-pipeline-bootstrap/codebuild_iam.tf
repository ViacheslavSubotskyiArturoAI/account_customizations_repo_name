data "aws_iam_policy_document" "codebuild_skynet_mgmt_pipeline_assume_role_policy" {
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

resource "aws_iam_role" "codebuild_skynet_mgmt_pipeline_role" {
  name               = "${local.prefix}-mgmt-pipeline-codebuild-service-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_skynet_mgmt_pipeline_assume_role_policy.json
}

data "aws_iam_policy_document" "codebuild_skynet_mgmt_pipeline_logging_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.tf_plan.name}",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.tf_plan.name}:*",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.tf_apply.name}",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.tf_apply.name}:*",
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_skynet_mgmt_pipeline_logging_access_policy" {
  name   = "logging_access"
  role   = aws_iam_role.codebuild_skynet_mgmt_pipeline_role.name
  policy = data.aws_iam_policy_document.codebuild_skynet_mgmt_pipeline_logging_access_policy.json
}

data "aws_iam_policy_document" "codebuild_skynet_mgmt_pipeline_s3_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      aws_s3_bucket.codepipeline.arn,
      "${aws_s3_bucket.codepipeline.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_skynet_mgmt_pipeline_s3_access" {
  name   = "s3_access"
  role   = aws_iam_role.codebuild_skynet_mgmt_pipeline_role.name
  policy = data.aws_iam_policy_document.codebuild_skynet_mgmt_pipeline_s3_access_policy.json
}
