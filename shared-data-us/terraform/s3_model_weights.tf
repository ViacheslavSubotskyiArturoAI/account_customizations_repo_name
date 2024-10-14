locals {
  model_weights_bucket_name = "skynet-us-model-weights-${local.account_id}"
}

resource "aws_s3_bucket" "model_weights" {
  bucket = local.model_weights_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "model_weights" {
  bucket = aws_s3_bucket.model_weights.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "model_weights" {
  bucket = aws_s3_bucket.model_weights.id
  policy = data.aws_iam_policy_document.s3_bucket_model_weights.json
}

data "aws_iam_policy_document" "s3_bucket_model_weights" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetLifecycleConfiguration",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      aws_s3_bucket.model_weights.arn,
      "${aws_s3_bucket.model_weights.arn}/*",
    ]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:PrincipalOrgPaths"
      values   = local.s3_model_weights_allowed_ro_principal_org_paths
    }
  }
}
