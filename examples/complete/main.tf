#--------------------------------------------------------------
# Main
#--------------------------------------------------------------

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

module "tfstate_backend" {
  source = "../../"

  bucket        = "tf-state-${local.aws_account_id}-${var.region}"
  force_destroy = true

  dynamodb_table = "tf-state-lock-${local.aws_account_id}-${var.region}"

  assume_role_principals = ["arn:aws:iam::123456789012:role/foobar"]

  create_backend_config = true
}
