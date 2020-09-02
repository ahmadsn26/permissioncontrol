data "aws_caller_identity" "_" {}
provider "aws" {
  region = "us-east-1"
}
# -----------------------------------------------------------------------------
# Modules
# -----------------------------------------------------------------------------


# module.identity
module "identity" {
  source = "./modules/identity"
  region = "${var.region}"

  cognito_identity_pool_name     = "${var.cognito_identity_pool_name}"
  cognito_identity_pool_provider = "${var.cognito_identity_pool_provider}"
}
