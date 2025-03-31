<div align="center">
  <h3>terraform-aws-tfstate-backend</h3>
  <p>Terraform S3 backend state module</p>
  <p>
    <!-- Build Status -->
    <a href="https://actions-badge.atrox.dev/hansohn/terraform-aws-tfstate-backend/goto?ref=main">
      <img src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fhansohn%2Fterraform-aws-tfstate-backend%2Fbadge%3Fref%3Dmain&style=for-the-badge">
    </a>
    <!-- Github Tag -->
    <a href="https://gitHub.com/hansohn/terraform-aws-tfstate-backend/tags/">
      <img src="https://img.shields.io/github/tag/hansohn/terraform-aws-tfstate-backend.svg?style=for-the-badge">
    </a>
    <!-- License -->
    <a href="https://github.com/hansohn/terraform-aws-tfstate-backend/blob/main/LICENSE">
      <img src="https://img.shields.io/github/license/hansohn/terraform-aws-tfstate-backend.svg?style=for-the-badge">
    </a>
    <!-- LinkedIn -->
    <a href="https://linkedin.com/in/ryanhansohn">
      <img src="https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555">
    </a>
  </p>
</div>

## Usage

Welcome to the terraform-aws-tfstate-backend repo!

## Examples

Please see the sample set of examples below for a better understanding of implementation

- [Complete](examples/complete) - Complete Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3"></a> [s3](#module\_s3) | hansohn/s3/aws | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.dynamodb_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.dynamodb_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [local_file.backend](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dynamodb_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_principals"></a> [assume\_role\_principals](#input\_assume\_role\_principals) | (Required) List of role ARNs to grant asumme role permission to. Required if creating IAM role. | `list(string)` | `[]` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | (Optional) Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY\_PER\_REQUEST. Defaults to PROVISIONED. | `string` | `"PROVISIONED"` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | (Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name. | `string` | `""` | no |
| <a name="input_create_backend_config"></a> [create\_backend\_config](#input\_create\_backend\_config) | (Optional) Create a backend config file for Terraform. Defaults to 'true'. If set to false, you will need to manually configure the backend in your Terraform configuration. | `bool` | `true` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | A boolean that enables deletion protection for DynamoDB table | `bool` | `false` | no |
| <a name="input_dynamodb_table"></a> [dynamodb\_table](#input\_dynamodb\_table) | (Required) The name of the table, this needs to be unique within a region. | `string` | `""` | no |
| <a name="input_enable_iam"></a> [enable\_iam](#input\_enable\_iam) | (Optional) Enable/disable IAM resource creation. Defaults to 'true'. | `bool` | `true` | no |
| <a name="input_enable_point_in_time_recovery"></a> [enable\_point\_in\_time\_recovery](#input\_enable\_point\_in\_time\_recovery) | Enable DynamoDB point-in-time recovery | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Enable/disable resource creation. Defaults to 'true'. | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean string that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable | `bool` | `false` | no |
| <a name="input_key"></a> [key](#input\_key) | (Required) The path to the state file inside the bucket. When using a non-default workspace, the state path will be /workspace\_key\_prefix/workspace\_name/key | `string` | `""` | no |
| <a name="input_kms_master_key_arn"></a> [kms\_master\_key\_arn](#input\_kms\_master\_key\_arn) | The AWS KMS master key ARN used for the `SSE-KMS` encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms` | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy | `string` | `""` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | (Optional) The number of read units for this table. If the billing\_mode is PROVISIONED, this field is required. | `number` | `20` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | (Optional) The role to be assumed. | `string` | `""` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | (Optional) Description of the role configured with Terraform backend state access | `string` | `"Code deployment role"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | (Optional) Name of the role configured with Terraform backend state access | `string` | `"CodeDeployRole"` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | (Optional) Path to the role configured with Terraform backend state access | `string` | `"/Org/"` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms` | `string` | `"AES256"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to resources. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `null` | no |
| <a name="input_terraform_backend_config_file_name"></a> [terraform\_backend\_config\_file\_name](#input\_terraform\_backend\_config\_file\_name) | Name of terraform backend config file | `string` | `"backend.tf"` | no |
| <a name="input_terraform_backend_config_file_path"></a> [terraform\_backend\_config\_file\_path](#input\_terraform\_backend\_config\_file\_path) | The path to terrafrom project directory | `string` | `"./configs"` | no |
| <a name="input_terraform_backend_config_template_file"></a> [terraform\_backend\_config\_template\_file](#input\_terraform\_backend\_config\_template\_file) | The path to the template used to generate the config file | `string` | `""` | no |
| <a name="input_terraform_state_file"></a> [terraform\_state\_file](#input\_terraform\_state\_file) | (Required) The path to the state file inside the bucket. When using a non-default workspace, the state path will be /workspace\_key\_prefix/workspace\_name/key | `string` | `"terraform.tfstate"` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | The minimum required terraform version | `string` | `"1.0.0"` | no |
| <a name="input_use_s3_lockfile"></a> [use\_s3\_lockfile](#input\_use\_s3\_lockfile) | Optional) Whether to use a lockfile for locking the state file. Defaults to true. | `bool` | `false` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | (Optional) The number of write units for this table. If the billing\_mode is PROVISIONED, this field is required. | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The name of the bucket. |
| <a name="output_dynamodb_arn"></a> [dynamodb\_arn](#output\_dynamodb\_arn) | The arn of the table. |
| <a name="output_dynamodb_id"></a> [dynamodb\_id](#output\_dynamodb\_id) | The id of the table. |
<!-- END_TF_DOCS -->

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
