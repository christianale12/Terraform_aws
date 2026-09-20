variable "region" {
  description = "Region AWS"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket" {
  description = "Nombre del bucket que guarda el estado remoto"
  type        = string
  default     = "christian-tfstate"
}

variable "lock_table" {
  description = "Nombre de la tabla DynamoDB para el lock del estado"
  type        = string
  default     = "terraform-locks"
}