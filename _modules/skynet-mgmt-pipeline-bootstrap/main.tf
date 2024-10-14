terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.69.0"
    }
  }
}

module "utils" {
  source  = "cloudposse/utils/aws"
  version = "1.4.0"
}
