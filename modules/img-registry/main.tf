# DigitalOcean Container Registry module
# This module creates a DigitalOcean Container Registry for storing Docker images

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Create DigitalOcean Container Registry
resource "digitalocean_container_registry" "main" {
  name                   = var.registry_name
  subscription_tier_slug = "starter"  # Free tier with 500MB storage
  region                 = var.region
}

# Create registry API key for authentication
resource "digitalocean_container_registry_docker_credentials" "main" {
  registry_name = digitalocean_container_registry.main.name
  write         = true
}
