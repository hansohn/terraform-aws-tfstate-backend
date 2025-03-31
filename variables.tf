#--------------------------------------------------------------
# General
#--------------------------------------------------------------

variable "enabled" {
  type        = bool
  default     = true
  description = "(Optional) Enable/disable resource creation. Defaults to 'true'."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) A map of tags to assign to resources. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}

#--------------------------------------------------------------
# S3
#--------------------------------------------------------------

variable "bucket" {
  type        = string
  default     = ""
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean string that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
}

variable "policy" {
  type        = string
  default     = ""
  description = "A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy"
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
}

variable "kms_master_key_arn" {
  type        = string
  default     = null
  description = "The AWS KMS master key ARN used for the `SSE-KMS` encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms`"
}

#--------------------------------------------------------------
# DynamoDB
#--------------------------------------------------------------

variable "dynamodb_table" {
  type        = string
  default     = ""
  description = "(Required) The name of the table, this needs to be unique within a region."
}

variable "billing_mode" {
  type        = string
  default     = "PROVISIONED"
  description = "(Optional) Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST. Defaults to PROVISIONED."
}

variable "read_capacity" {
  type        = number
  default     = 20
  description = "(Optional) The number of read units for this table. If the billing_mode is PROVISIONED, this field is required."
}

variable "write_capacity" {
  type        = number
  default     = 20
  description = "(Optional) The number of write units for this table. If the billing_mode is PROVISIONED, this field is required."
}

variable "enable_point_in_time_recovery" {
  type        = bool
  default     = true
  description = "Enable DynamoDB point-in-time recovery"
}

variable "deletion_protection_enabled" {
  type        = bool
  default     = false
  description = "A boolean that enables deletion protection for DynamoDB table"
}

#--------------------------------------------------------------
# IAM
#--------------------------------------------------------------

variable "enable_iam" {
  type        = bool
  default     = true
  description = "(Optional) Enable/disable IAM resource creation. Defaults to 'true'."
}

variable "role_name" {
  type        = string
  default     = "CodeDeployRole"
  description = "(Optional) Name of the role configured with Terraform backend state access"
}

variable "role_path" {
  type        = string
  default     = "/Org/"
  description = "(Optional) Path to the role configured with Terraform backend state access"
}

variable "role_description" {
  type        = string
  default     = "Code deployment role"
  description = "(Optional) Description of the role configured with Terraform backend state access"
}

variable "assume_role_principals" {
  type        = list(string)
  default     = []
  description = "(Required) List of role ARNs to grant asumme role permission to. Required if creating IAM role."
}

#--------------------------------------------------------------
# Terraform Backend S3
#--------------------------------------------------------------

variable "create_backend_config" {
  type        = bool
  default     = true
  description = "(Optional) Create a backend config file for Terraform. Defaults to 'true'. If set to false, you will need to manually configure the backend in your Terraform configuration."
}

variable "key" {
  type        = string
  default     = ""
  description = "(Required) The path to the state file inside the bucket. When using a non-default workspace, the state path will be /workspace_key_prefix/workspace_name/key"
}

variable "role_arn" {
  type        = string
  default     = ""
  description = "(Optional) The role to be assumed."
}

variable "terraform_backend_config_file_name" {
  type        = string
  default     = "backend.tf"
  description = "Name of terraform backend config file"
}

variable "terraform_backend_config_file_path" {
  type        = string
  default     = "./configs"
  description = "The path to terrafrom project directory"
}

variable "terraform_backend_config_template_file" {
  type        = string
  default     = ""
  description = "The path to the template used to generate the config file"
}

variable "terraform_version" {
  type        = string
  default     = "1.0.0"
  description = "The minimum required terraform version"
}

variable "terraform_state_file" {
  type        = string
  default     = "terraform.tfstate"
  description = "(Required) The path to the state file inside the bucket. When using a non-default workspace, the state path will be /workspace_key_prefix/workspace_name/key"
}

variable "use_s3_lockfile" {
  type        = bool
  default     = false
  description = "Optional) Whether to use a lockfile for locking the state file. Defaults to true."
}
