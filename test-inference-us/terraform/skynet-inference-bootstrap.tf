module "skynet_inference_bootstrap" {
  source = "../../_modules/skynet-inference-bootstrap"

  environment                     = "test"
  skynet_mgmt_pipeline_account_id = "241533157109"
}
