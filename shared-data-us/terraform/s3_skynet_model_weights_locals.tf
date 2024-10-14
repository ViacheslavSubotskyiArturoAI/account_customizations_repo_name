locals {
  s3_skynet_model_weights_bucket_name = "skynet-us-model-weights-${local.account_id}"
  s3_skynet_model_weights_allowed_ro_principal_org_paths = [
    "${local.org_id}/${local.org_root_id}/${local.org_ou_prod_id}/*",
    "${local.org_id}/${local.org_root_id}/${local.org_ou_non_prod_id}/*"
  ]
}
