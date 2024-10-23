resource "aws_dynamodb_table" "tf_state" {
  name         = local.tf_state_dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  depends_on = [
    aws_iam_role.codebuild_skynet_mgmt_pipeline_role,
    aws_iam_role.codebuild_skynet_inference_role
  ]
}

resource "aws_dynamodb_resource_policy" "tf_state" {
  resource_arn = aws_dynamodb_table.tf_state.arn
  policy       = data.aws_iam_policy_document.dynamodb_table_tf_state.json
}

data "aws_iam_policy_document" "dynamodb_table_tf_state" {
  statement {
    principals {
      type        = "AWS"
      identifiers = local.tf_state_allowed_iam_identities
    }
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
    resources = [aws_dynamodb_table.tf_state.arn]
  }
}
