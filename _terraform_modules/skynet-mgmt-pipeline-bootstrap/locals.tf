locals {
  region       = data.aws_region.this.name
  account_id   = data.aws_caller_identity.this.account_id
  region_short = module.utils.region_az_alt_code_maps["to_short"][local.region]
  prefix       = "${var.environment}-skynet-${local.region_short}"

  tf_state_s3_bucket_name      = "${local.prefix}-tf-state-${local.account_id}"
  tf_state_dynamodb_table_name = "${local.prefix}-tf-state-locks"
  tf_state_allowed_iam_identities = concat(
    [
      aws_iam_role.codebuild_skynet_mgmt_pipeline_role.arn,
      aws_iam_role.codebuild_skynet_inference_role.arn,
    ],
    var.extra_allowed_iam_identities
  )

  tf_deploy_allowed_iam_identities = concat(
    [aws_iam_role.codebuild_skynet_mgmt_pipeline_role.arn],
    var.extra_allowed_iam_identities
  )

  codepipeline_prefix         = "${local.prefix}-codepipeline"
  codepipeline_s3_bucket_name = "${local.codepipeline_prefix}-${local.account_id}"

  codebuild_mgmt_pipeline_work_dir = "env/${var.environment_type}/${var.environment}/${local.region}/mgmt-pipeline"

  codebuild_project = {
    tf_plan  = "${local.prefix}-mgmt-pipeline-tf-plan"
    tf_apply = "${local.prefix}-mgmt-pipeline-tf-apply"
  }

  codebuild_inference_prefix = "${local.prefix}-inference-codebuild"
}
