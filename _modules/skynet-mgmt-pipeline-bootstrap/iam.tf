data "aws_iam_policy_document" "tf_deploy_iam_access_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["iam:*"]
    resources = ["arn:aws:iam::${local.account_id}:role/${local.prefix}*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "iam:CreateServiceLinkedRole",
      "iam:GetRole",
      "iam:DeleteServiceLinkedRole",
      "iam:GetServiceLinkedRoleDeletionStatus",
      "iam:TagRole"
    ]
    resources = ["arn:aws:iam::${local.account_id}:role/aws-service-role/replication.ecr.amazonaws.com/AWSServiceRoleForECRReplication"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_iam_access" {
  name   = "iam_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_iam_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_ecr_access_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["ecr:*"]
    resources = ["arn:aws:ecr:${local.region}:${local.account_id}:repository/${local.prefix}*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:PutRegistryPolicy",
      "ecr:PutReplicationConfiguration",
      "ecr:GetRegistryPolicy",
      "ecr:DescribeRegistry",
      "ecr:DeleteRegistryPolicy",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_ecr_access" {
  name   = "ecr_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_ecr_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_s3_access_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${local.prefix}*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_s3_access_policy" {
  name   = "s3_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_s3_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_codepipeline_access_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["codepipeline:*"]
    resources = ["arn:aws:codepipeline:${local.region}:${local.account_id}:${local.prefix}*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_codepipeline_access" {
  name   = "codepipeline_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_codepipeline_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_codebuild_access_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["codebuild:*"]
    resources = ["arn:aws:codebuild:${local.region}:${local.account_id}:project/${local.prefix}*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_codebuild_access" {
  name   = "codebuild_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_codebuild_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_codeconnection_access_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:ListConnections"]
    resources = ["arn:aws:codestar-connections:${local.region}:${local.account_id}:*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "codestar-connections:Get*",
      "codestar-connections:List*",
      "codestar-connections:Use*",
      "codestar-connections:Pass*"
    ]
    resources = [aws_codestarconnections_connection.this.arn]
  }
}

resource "aws_iam_role_policy" "tf_deploy_codeconnection_access" {
  name   = "codeconnection_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_codeconnection_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_cloudwatch_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:TagResource",
      "logs:PutRetentionPolicy",
      "logs:DescribeLogGroups",
      "logs:ListTagsForResource",
      "logs:DeleteLogGroup"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_cloudwatch_access" {
  name   = "cloudwatch_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_cloudwatch_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_ec2_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = ["ec2:DescribeRegions"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_ec2_access" {
  name   = "ec2_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_ec2_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_assume_role_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
      "sts:SetSourceIdentity",
    ]
    principals {
      type        = "AWS"
      identifiers = local.tf_deploy_allowed_iam_identities
    }
  }
}

resource "aws_iam_role" "tf_deploy" {
  name               = "${local.prefix}-mgmt-pipeline-tf-deploy"
  assume_role_policy = data.aws_iam_policy_document.tf_deploy_assume_role_policy.json
}
