data "aws_iam_policy_document" "tf_deploy_iam_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListInstanceProfilesForRole",
      "iam:DeleteRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole"
    ]
    resources = ["arn:aws:iam::${local.account_id}:role/${local.prefix}*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_iam_access" {
  name   = "iam_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_iam_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_lambda_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "lambda:CreateFunction",
      "lambda:GetFunction",
      "lambda:ListVersionsByFunction",
      "lambda:DeleteFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:AddPermission",
      "lambda:GetPolicy",
      "lambda:RemovePermission",
      "lambda:InvokeFunction",
      "lambda:ListTags",
      "lambda:TagResource"
    ]
    resources = ["arn:aws:lambda:${local.region}:${local.account_id}:function:${local.prefix}*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_lambda_access" {
  name   = "lambda_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_lambda_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_ecr_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DeleteRepositoryPolicy",
      "ecr:GetRepositoryPolicy",
      "ecr:SetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
    ]
    resources = [
      "arn:aws:ecr:${local.region}:${local.account_id}:repository/${local.prefix}*",
      "arn:aws:ecr:${local.region}:${var.skynet_mgmt_pipeline_account_id}:repository/${local.prefix}*",
    ]
  }
}

resource "aws_iam_role_policy" "tf_deploy_ecr_access" {
  name   = "ecr_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_ecr_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_secrets_manager_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:RotateSecret",
      "secretsmanager:CancelRotateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:PutSecretValue",
      "secretsmanager:GetSecretValue",
      "secretsmanager:TagResource",
      "secretsmanager:UpdateSecretVersionStage",
    ]
    resources = ["arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:${local.prefix}/vexcel/*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_secrets_manager_access" {
  name   = "secrets_manager_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_secrets_manager_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_s3_access_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${local.execution_data_dump_s3_bucket_name}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetLifecycleConfiguration",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectTagging",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
    ]
    resources = [
      "arn:aws:s3:::${local.prefix}*",
      "arn:aws:s3:::${local.prefix}*/*",
    ]
  }
}

resource "aws_iam_role_policy" "tf_deploy_s3_access_policy" {
  name   = "s3_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_s3_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_sagemaker_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sagemaker:CreateModel",
      "sagemaker:DescribeModel",
      "sagemaker:ListTags",
      "sagemaker:DeleteModel",
      "sagemaker:CreateEndpointConfig",
      "sagemaker:DescribeEndpointConfig",
      "sagemaker:ListEndpointConfigs",
      "sagemaker:DeleteEndpointConfig",
      "sagemaker:CreateEndpoint",
      "sagemaker:DescribeEndpoint",
      "sagemaker:DeleteEndpoint",
      "sagemaker:UpdateEndpoint",
      "sagemaker:UpdateEndpointWeightsAndCapacities",
      "sagemaker:AddTags"
    ]
    resources = [
      "arn:aws:sagemaker:${local.region}:${local.account_id}:model/${local.prefix}*",
      "arn:aws:sagemaker:${local.region}:${local.account_id}:endpoint-config/${local.prefix}*",
      "arn:aws:sagemaker:${local.region}:${local.account_id}:endpoint/${local.prefix}*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "sagemaker:DescribeEndpoint",
      "sagemaker:UpdateEndpointWeightsAndCapacities",
      "sagemaker:InvokeEndpoint",
      "sagemaker:DescribeEndpointConfig",
    ]
    resources = [
      "arn:aws:sagemaker:${local.region}:${local.account_id}:endpoint/${local.prefix}*",
      "arn:aws:sagemaker:${local.region}:${local.account_id}:endpoint-config/${local.prefix}*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "application-autoscaling:RegisterScalableTarget",
      "application-autoscaling:PutScalingPolicy",
      "application-autoscaling:DeleteScalingPolicy",
      "application-autoscaling:DescribeScalableTargets",
      "application-autoscaling:ListTagsForResource",
      "application-autoscaling:DeregisterScalableTarget",
      "application-autoscaling:DescribeScalingPolicies",
      "application-autoscaling:TagResource"
    ]
    resources = [
      "arn:aws:application-autoscaling:${local.region}:${local.account_id}:scalable-target/*",
      "arn:aws:application-autoscaling:${local.region}:${local.account_id}:scaling-policy/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListTagsForResource",
      "cloudwatch:TagResource"
    ]
    resources = [
      "arn:aws:cloudwatch:${local.region}:${local.account_id}:alarm:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateServiceLinkedRole",
      "iam:GetRole",
      "iam:DeleteServiceLinkedRole",
      "iam:GetServiceLinkedRoleDeletionStatus",
      "iam:TagRole"
    ]
    resources = [
      "arn:aws:iam::${local.account_id}:role/aws-service-role/sagemaker.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_SageMakerEndpoint"
    ]
  }
}

resource "aws_iam_role_policy" "tf_deploy_sagemaker_access_policy" {
  name   = "sagemaker_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_sagemaker_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_state_machine_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "states:CreateStateMachine",
      "states:DescribeStateMachine",
      "states:ListStateMachineVersions",
      "states:ListTagsForResource",
      "states:DeleteStateMachine",
      "states:UpdateStateMachine",
      "states:TagResource"
    ]
    resources = ["arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.prefix}*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["states:ValidateStateMachineDefinition"]
    resources = ["arn:aws:states:${local.region}:${local.account_id}:stateMachine:*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy",
      "logs:DescribeLogGroups",
      "logs:ListTagsForResource",
      "logs:DeleteLogGroup",

      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",

      "logs:PutLogEvents",
      "logs:PutDestination",
      "logs:PutDestinationPolicy",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:TagResource"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_state_machine_access" {
  name   = "state_machine_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_state_machine_access_policy.json
}

data "aws_iam_policy_document" "tf_deploy_api_gateway_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "apigateway:POST",
      "apigateway:GET",
      "apigateway:DELETE",
      "apigateway:PUT",
      "apigateway:PATCH",
    ]
    resources = [
      "arn:aws:apigateway:${local.region}::/restapis*",
      "arn:aws:apigateway:${local.region}::/apikeys*",
      "arn:aws:apigateway:${local.region}::/usageplans*",
      "arn:aws:apigateway:${local.region}::/account*",
      "arn:aws:apigateway:${local.region}::/tags*",
    ]
  }
}

resource "aws_iam_role_policy" "tf_deploy_api_gateway_access" {
  name   = "api_gateway_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_api_gateway_access_policy.json
}


data "aws_iam_policy_document" "tf_deploy_sns_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "SNS:CreateTopic",
      "SNS:SetTopicAttributes",
      "SNS:GetTopicAttributes",
      "SNS:ListTagsForResource",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:Unsubscribe",
      "SNS:GetSubscriptionAttributes",
      "SNS:SetSubscriptionAttributes",
      "SNS:TagResource"
    ]
    resources = [
      "arn:aws:sns:${local.region}:*",
    ]
  }
}

resource "aws_iam_role_policy" "tf_deploy_sns_access" {
  name   = "sns_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_sns_access_policy.json
}


data "aws_iam_policy_document" "tf_deploy_dynamodb_access_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:*"]
    resources = ["arn:aws:dynamodb:${local.region}:${local.account_id}:table/${local.prefix}*"]
  }
}

resource "aws_iam_role_policy" "tf_deploy_dynamodb_access" {
  name   = "dynamodb_access"
  role   = aws_iam_role.tf_deploy.name
  policy = data.aws_iam_policy_document.tf_deploy_dynamodb_access_policy.json
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
  name               = "${local.prefix}-inference-tf-deploy"
  assume_role_policy = data.aws_iam_policy_document.tf_deploy_assume_role_policy.json
}

resource "aws_iam_service_linked_role" "sagemaker_autoscalling" {
  count = var.deploy_account_wide_resources ? 1 : 0

  aws_service_name = "sagemaker.application-autoscaling.amazonaws.com"
}
