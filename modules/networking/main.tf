# Networking module for DigitalOcean VPC
# This module creates a VPC and associated networking resources

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Create VPC
resource "digitalocean_vpc" "main" {
  name     = var.vpc_name
  region   = var.vpc_region
  ip_range = "10.30.0.0/16"
}
