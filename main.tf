data "aws_region" "current" {}

locals {
  aws_region = data.aws_region.current.name
}

#--------------------------------------------------------------
# S3
#--------------------------------------------------------------

module "s3" {
  source  = "hansohn/s3/aws"
  version = "~> 2.0"
  enable  = var.enabled

  bucket                       = var.bucket
  force_destroy                = var.force_destroy
  enable_versioning            = true
  encryption_sse_algorithm     = var.sse_algorithm
  encryption_kms_master_key_id = var.kms_master_key_arn
  policy                       = var.policy
  tags                         = var.tags
}

#--------------------------------------------------------------
# DynamoDB
#--------------------------------------------------------------

#tfsec:ignore:aws-dynamodb-table-customer-key
resource "aws_dynamodb_table" "this" {
  count                       = var.enabled && !var.use_s3_lockfile ? 1 : 0
  name                        = var.dynamodb_table
  billing_mode                = var.billing_mode
  hash_key                    = "LockID"
  read_capacity               = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity              = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  deletion_protection_enabled = var.deletion_protection_enabled

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}

#--------------------------------------------------------------
# IAM
#--------------------------------------------------------------

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.enabled && var.enable_iam ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.assume_role_principals
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.enabled && var.enable_iam ? 1 : 0

  name               = var.role_name
  path               = var.role_path
  description        = var.role_description
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[0].json
  tags               = var.tags
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "s3_policy" {
  count = var.enabled && var.enable_iam ? 1 : 0

  statement {
    sid    = "S3ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      module.s3.arn
    ]
  }

  statement {
    sid    = "S3PutObject"
    effect = "Allow"
    actions = [
      "s3:GetObject*",
      "s3:ListObject*",
      "s3:PutObject*",
    ]
    resources = [
      "${module.s3.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_policy" {
  count = var.enabled && var.enable_iam ? 1 : 0

  name        = "TerraformBackendStateS3Policy"
  description = "Terraform backend state S3 policy"
  policy      = data.aws_iam_policy_document.s3_policy[0].json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  count = var.enabled && var.enable_iam ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.s3_policy[0].arn
}

data "aws_iam_policy_document" "dynamodb_policy" {
  count = var.enabled && var.enable_iam && !var.use_s3_lockfile ? 1 : 0

  statement {
    sid    = "DynamoDBReadWrite"
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
    ]
    resources = [
      aws_dynamodb_table.this[0].arn
    ]
  }
}

resource "aws_iam_policy" "dynamodb_policy" {
  count = var.enabled && var.enable_iam && !var.use_s3_lockfile ? 1 : 0

  name        = "TerraformBackendStateDynamoDBPolicy"
  description = "Terraform backend state DynamoDB policy"
  policy      = data.aws_iam_policy_document.dynamodb_policy[0].json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy" {
  count = var.enabled && var.enable_iam && !var.use_s3_lockfile ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.dynamodb_policy[0].arn
}

#--------------------------------------------------------------
# Terraform Backend Init
#--------------------------------------------------------------

locals {
  terraform_backend_config_file = format(
    "%s/%s",
    var.terraform_backend_config_file_path,
    var.terraform_backend_config_file_name
  )
  terraform_backend_config_template_file = coalesce(
    var.terraform_backend_config_template_file,
    "${path.module}/templates/terraform.tf.tpl"
  )
  terraform_backend_config_content = templatefile(local.terraform_backend_config_template_file, {
    terraform_version = var.terraform_version
    bucket            = module.s3.id
    key               = "${var.key}/${var.terraform_state_file}"
    region            = local.aws_region
    dynamodb_table    = !var.use_s3_lockfile ? aws_dynamodb_table.this[0].id : null
    encrypt           = "true"
    role_arn          = var.enable_iam ? aws_iam_role.this[0].arn : var.role_arn
    use_lockfile      = var.use_s3_lockfile
  })
}

resource "local_file" "backend" {
  count           = var.enabled && var.create_backend_config ? 1 : 0
  content         = local.terraform_backend_config_content
  filename        = local.terraform_backend_config_file
  file_permission = "0644"
}
