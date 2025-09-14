# Backend configuration for Terraform state management
# Using local backend for immediate functionality

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Alternative: Use DigitalOcean Spaces for remote state storage
# Uncomment the following block and comment out the local backend above
# terraform {
#   backend "s3" {
#     # DigitalOcean Spaces (S3-compatible object storage)
#     endpoint                    = "https://nyc3.digitaloceanspaces.com"
#     region                      = "nyc3"
#     bucket                      = "vk-terraform-state-bucket-doc"
#     key                         = "dev/terraform.tfstate"
#     skip_credentials_validation = true
#     skip_metadata_api_check     = true
#     skip_region_validation      = true
#     
#     # Set DigitalOcean Spaces credentials (uses AWS_* names for S3 compatibility):
#     # export AWS_ACCESS_KEY_ID="your_spaces_access_key"
#     # export AWS_SECRET_ACCESS_KEY="your_spaces_secret_key"
#   }
# }
