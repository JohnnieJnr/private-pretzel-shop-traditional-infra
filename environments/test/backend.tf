terraform {
  backend "s3" {
    bucket         = "pretzel-shop-tfstate-bucket"
    key            = "test/terraform.tfstate"
    encrypt = true
    endpoints = {
        s3 = "https://sfo3.digitaloceanspaces.com"
    }   
    # Deactivate a few AWS-specific checks
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "us-east-1"    
  }
}