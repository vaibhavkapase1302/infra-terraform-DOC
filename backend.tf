# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }

# Remote state via DigitalOcean Spaces (S3-compatible)
# To enable later, replace the local backend above with the following and set env vars
# AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY for Spaces access keys.
terraform {
  backend "s3" {
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "vk-terraform-state-bucket-doc"
    key                         = "terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}