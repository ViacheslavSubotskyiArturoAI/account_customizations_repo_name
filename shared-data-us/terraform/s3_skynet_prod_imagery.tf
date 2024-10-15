resource "aws_s3_bucket" "skynet_prod_imagery" {
  bucket = local.s3_skynet_prod_imagery_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "skynet_prod_imagery" {
  bucket = aws_s3_bucket.skynet_prod_imagery.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "skynet_prod_imagery" {
  bucket = aws_s3_bucket.skynet_prod_imagery.id
  policy = data.aws_iam_policy_document.s3_bucket_skynet_prod_imagery.json
}

data "aws_iam_policy_document" "s3_bucket_skynet_prod_imagery" {
  statement {
    principals {
      type        = "AWS"
      identifiers = local.s3_skynet_prod_allowed_rw_aws_principals_identifiers
    }
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      aws_s3_bucket.skynet_prod_imagery.arn,
      "${aws_s3_bucket.skynet_prod_imagery.arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [local.org_id]
    }
  }
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.skynet_prod_imagery.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = local.s3_skynet_prod_allowed_ro_cloudfront_source_arns
    }
  }
}
