data "aws_iam_policy_document" "replication_policy" {
  version = "2012-10-17"
  statement {
    sid    = "${local.prefix}-ecr-replication"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.skynet_mgmt_pipeline_account_id}:root"]
    }
    actions = [
      "ecr:CreateRepository",
      "ecr:ReplicateImage",
      "ecr:BatchImportUpstreamImage"
    ]
    resources = [
      "arn:aws:ecr:${local.region}:${local.account_id}:repository/${local.prefix}*"
    ]
  }
}

resource "aws_ecr_registry_policy" "this" {
  count = var.deploy_region_wide_resources ? 1 : 0

  policy = data.aws_iam_policy_document.replication_policy.json
}
