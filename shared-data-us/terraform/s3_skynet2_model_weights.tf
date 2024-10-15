resource "aws_s3_bucket" "skynet2_model_weights" {
  bucket = local.s3_skynet2_model_weights_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "skynet2_model_weights" {
  bucket = aws_s3_bucket.skynet2_model_weights.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "skynet2_model_weights" {
  bucket = aws_s3_bucket.skynet2_model_weights.id
  policy = data.aws_iam_policy_document.s3_bucket_skynet2_model_weights.json
}

data "aws_iam_policy_document" "s3_bucket_skynet2_model_weights" {
  statement {
    principals {
      type        = "*"
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
      aws_s3_bucket.skynet2_model_weights.arn,
      "${aws_s3_bucket.skynet2_model_weights.arn}/*",
    ]
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values   = local.s3_skynet2_model_weights_allowed_ro_principal_org_paths
    }
  }
}
