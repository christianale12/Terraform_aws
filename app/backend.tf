terraform {
  backend "s3" {
    bucket         = "christian-tfstate"
    key            = "app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"

    endpoints = {
      s3       = "http://localhost:9000"
      dynamodb = "http://localhost:8000"
    }

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    skip_metadata_api_check     = true
    use_path_style              = true
  }
}