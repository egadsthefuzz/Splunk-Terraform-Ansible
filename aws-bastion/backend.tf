terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "ap-southeast-2"
    bucket         = "egadsthefuzz-test-terraform-statestore"
    key            = "terraform.tfstate"
    dynamodb_table = "egadsthefuzz-test-terraform-statestore-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}


# you cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
module terraform_state_backend {
  source     = "git::https://github.com/egadsthefuzz/terraform-aws-tfstate-backend.git?ref=safety-changes"
  namespace  = "egadsthefuzz"
  stage      = "test"
  name       = "terraform"
  attributes = ["statestore"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend-out.tf"
  force_destroy                      = false
}

# Set AWS as the provider and establish creds and default region
provider aws {
  alias = "backend_aws"
  shared_credentials_file = var.backend_shared_credentials
  profile                 = var.backend_profile
  region                  = var.backend_region
}

variable "backend_shared_credentials" {
  default = "/home/william/.aws/credentials"
}

variable "backend_profile" {
  default = "default"
}
# AWS region
variable "backend_region" {
  default = "ap-southeast-2"
}
