variable "environment" {
  type        = string
  nullable    = false
  description = "Skynet environment name, e.g: poc, dev, prod."
}

variable "skynet_mgmt_pipeline_account_id" {
  type        = string
  nullable    = false
  description = "AWS Account ID for skynet_mgmt_pipeline account."
}

variable "deploy_region_wide_resources" {
  type        = bool
  default     = true
  description = "Deploy region-wide resources. Set it to 'false' in case of additional module deployment in the same region."
}

variable "deploy_account_wide_resources" {
  type        = bool
  default     = true
  description = "Deploy account-wide resources. Set it to 'false' in case of additional module deployment in the same account."
}

variable "extra_allowed_iam_identities" {
  type        = list(string)
  default     = []
  description = "List of the AWS IAM identities that are allowed to assume TF-deploy role."
}
