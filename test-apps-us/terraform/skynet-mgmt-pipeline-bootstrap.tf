module "skynet_mgmt_pipeline_bootstrap" {
  source = "../_modules/skynet-mgmt-pipeline-bootstrap"

  environment                            = "test"
  environment_type                       = "lower"
  skynet_on_demand_iac_repo_branch       = "dev"
  cloudwatch_log_group_retention_in_days = "30"
}
