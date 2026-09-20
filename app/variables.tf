variable "region" {
  description = "Region AWS"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Tags comunes a todos los recursos"
  type        = map(string)
  default     = {}
}