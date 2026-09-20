output "state_bucket" {
  description = "Bucket creado para el state remoto"
  value       = aws_s3_bucket.terraform_state.id
}

output "lock_table" {
  description = "Tabla creada para el lock del state"
  value       = aws_dynamodb_table.terraform_locks.name
}