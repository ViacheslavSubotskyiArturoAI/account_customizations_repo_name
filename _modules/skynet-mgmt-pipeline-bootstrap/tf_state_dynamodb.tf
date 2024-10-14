resource "aws_dynamodb_table" "tf_state" {
  name           = local.tf_state_dynamodb_table_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
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
    resources = [aws_dynamodb_table.tf_state.arn, ]
  }
}
