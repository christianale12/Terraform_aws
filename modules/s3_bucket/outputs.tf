output "bucket_id" {
  description = "ID del bucket creado"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN del bucket creado"
  value       = aws_s3_bucket.this.arn
}