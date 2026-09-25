data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "christian-tfstate"
    key    = "practicas/01-ec2/terraform.tfstate"
    region = "us-east-1"
    endpoints = {
      s3 = "http://localhost:9000"
    dynamodb = "http://localhost:8000" }
    use_path_style              = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}
