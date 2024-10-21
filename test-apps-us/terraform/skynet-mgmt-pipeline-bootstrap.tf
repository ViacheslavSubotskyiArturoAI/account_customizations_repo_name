module "skynet_mgmt_pipeline_bootstrap" {
  source = "../../_terraform_modules/skynet-mgmt-pipeline-bootstrap"

  environment                            = "test"
  environment_type                       = "lower"
  skynet_on_demand_iac_repo_branch       = "DEVOPSX-771-dev"
  cloudwatch_log_group_retention_in_days = "30"
}
