locals {
  s3_skynet_prod_execution_data_dump_bucket_name = "skynet-us-prod-execution-data-dump-${local.account_id}"
  s3_skynet_prod_execution_data_dump_allowed_rw_aws_principals_identifiers = [
    "575108956402" # Test-Inference-US
  ]
}
