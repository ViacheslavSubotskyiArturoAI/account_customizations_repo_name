locals {
  s3_skynet_prod_execution_data_dump_bucket_name         = "skynet-prod-us-execution-data-dump-${local.account_id}"
  s3_skynet_prod_execution_data_dump_replica_bucket_name = "skynet-prod-us-execution-data-dump-replica-${local.account_id}"
  s3_skynet_prod_execution_data_dump_allowed_rw_aws_principals_identifiers = [
    "575108956402" # Test-Inference-US
  ]
  s3_skynet_prod_execution_data_dump_allowed_ro_cloudfront_source_arns = [
    "arn:aws:cloudfront::543143522178:distribution/E3USKZVA881TUN",
    "arn:aws:cloudfront::543143522178:distribution/E1LAGOV9Z0XW9C",
    "arn:aws:cloudfront::543143522178:distribution/E19C0GIIPYQKXS"
  ]
}
