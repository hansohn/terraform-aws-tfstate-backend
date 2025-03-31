#--------------------------------------------------------------
# S3
#--------------------------------------------------------------

output "bucket_arn" {
  value       = module.s3.arn
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
}

output "bucket_id" {
  value       = module.s3.id
  description = "The name of the bucket."
}

#--------------------------------------------------------------
# DynamoDB
#--------------------------------------------------------------

output "dynamodb_arn" {
  value       = element([aws_dynamodb_table.this[*].arn, ""], 0)
  description = "The arn of the table."
}

output "dynamodb_id" {
  value       = element([aws_dynamodb_table.this[*].id, ""], 0)
  description = "The id of the table."
}

#--------------------------------------------------------------
# IAM
#--------------------------------------------------------------

