locals {
  region       = data.aws_region.this.name
  account_id   = data.aws_caller_identity.this.account_id
  region_short = module.utils.region_az_alt_code_maps["to_short"][local.region]
  prefix       = "${var.environment}-skynet-${local.region_short}"

  execution_data_dump_s3_bucket_name = "${local.prefix}-execution-data-dump-${local.account_id}"

  codebuild_service_role = "arn:aws:iam::${var.skynet_mgmt_pipeline_account_id}:role/${local.prefix}-inference-codebuild-service-role"

  tf_deploy_allowed_iam_identities = concat(
    [local.codebuild_service_role],
    var.extra_allowed_iam_identities
  )
}
