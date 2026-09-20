variable "name" {
  description = "Nombre del bucket S3"
  type        = string
}

variable "tags" {
  description = "Tags aplicados al bucket"
  type        = map(string)
  default     = {}
}

variable "versioning" {
  description = "Habilita versionado de objetos"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir el bucket aunque tenga objetos"
  type        = bool
  default     = false
}