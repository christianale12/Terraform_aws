terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = var.region
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
  endpoints {
    s3       = "http://localhost:9000"
    dynamodb = "http://localhost:8000"
  }
}

locals {
  name_prefix = "${var.project}-${var.environment}"
}

module "data_bucket" {
  source        = "../modules/s3_bucket"
  name          = "${local.name_prefix}-data"
  versioning    = true
  force_destroy = true
  tags          = var.tags
}

module "logs_bucket" {
  source        = "../modules/s3_bucket"
  name          = "${local.name_prefix}-logs"
  versioning    = false
  force_destroy = true
  tags          = var.tags
}

resource "aws_dynamodb_table" "app_table" {
  name         = "${local.name_prefix}_app"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"

  attribute {
    name = "PK"
    type = "S"
  }
}