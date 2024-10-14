locals {
  region     = data.aws_region.this.name
  account_id = data.aws_caller_identity.this.account_id
  org_id     = data.aws_organizations_organization.this.id

  org_root_id        = "r-gdnw"
  org_ou_prod_id     = "ou-gdnw-j823h20x"
  org_ou_non_prod_id = "ou-gdnw-6zk88t07"

  s3_model_weights_allowed_ro_principal_org_paths = [
    "${local.org_id}/${local.org_root_id}/${local.org_ou_prod_id}/*",
    "${local.org_id}/${local.org_root_id}/${local.org_ou_non_prod_id}/*"
  ]
}
