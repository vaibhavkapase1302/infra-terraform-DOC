# Backend configuration for Terraform state management
# Using local backend for immediate functionality

# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }

# Use DigitalOcean Spaces for remote state storage
# Uncomment the following block and comment out the local backend above
terraform {
  backend "s3" {
    # DigitalOcean Spaces (S3-compatible object storage)
    endpoint                    = "https://nyc3.digitaloceanspaces.com" 
    region                      = "us-east-1"
    bucket                      = "vk-terraform-state-bucket-doc"
    key                         = "terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}