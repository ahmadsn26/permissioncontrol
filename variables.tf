# var.region
variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

# -----------------------------------------------------------------------------
# Variables: Cognito
# -----------------------------------------------------------------------------

# var.cognito_identity_pool_name
variable "cognito_identity_pool_name" {
  description = "Cognito identity pool name"
  default     = "test"
}

# var.cognito_identity_pool_provider
variable "cognito_identity_pool_provider" {
  description = "Cognito identity pool provider"
  default     = "testapi.login.com"
}
