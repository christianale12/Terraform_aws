output "data_bucket_id" {
  description = "Bucket de datos"
  value       = module.data_bucket.bucket_id
}

output "data_bucket_arn" {
  description = "ARN del bucket de datos"
  value       = module.data_bucket.bucket_arn
}

output "logs_bucket_id" {
  description = "Bucket de logs"
  value       = module.logs_bucket.bucket_id
}

output "app_table_name" {
  description = "Tabla DynamoDB de la aplicacion"
  value       = aws_dynamodb_table.app_table.name
}