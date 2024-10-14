variable "environment" {
  type        = string
  nullable    = false
  description = "Skynet environment name, e.g: poc, dev, prod."
}

variable "environment_type" {
  type        = string
  nullable    = false
  description = "Skynet environment type(upper/lower)."
}

variable "skynet_on_demand_iac_repo_branch" {
  type        = string
  nullable    = false
  description = "Name for the skynet-on-demand-iac repository branch."
}

variable "extra_allowed_iam_identities" {
  type        = list(string)
  default     = []
  description = "List of the AWS IAM identities that are allowed to access Terraform state S3 bucket, state locks DynamoDB table and assume TF-deploy role."
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  default     = 365
  description = "The number of days to keep CloudWatch logs."
}
