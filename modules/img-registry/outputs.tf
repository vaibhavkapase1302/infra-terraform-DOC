# Outputs for the container registry module

output "registry_id" {
  description = "ID of the DigitalOcean Container Registry"
  value       = digitalocean_container_registry.main.id
}

output "registry_name" {
  description = "Name of the DigitalOcean Container Registry"
  value       = digitalocean_container_registry.main.name
}

output "registry_endpoint" {
  description = "Endpoint of the DigitalOcean Container Registry"
  value       = digitalocean_container_registry.main.endpoint
}

output "registry_server" {
  description = "Server URL of the DigitalOcean Container Registry"
  value       = digitalocean_container_registry.main.server_url
}

output "registry_region" {
  description = "Region of the DigitalOcean Container Registry"
  value       = digitalocean_container_registry.main.region
}

output "registry_subscription_tier" {
  description = "Subscription tier of the DigitalOcean Container Registry"
  value       = digitalocean_container_registry.main.subscription_tier_slug
}

output "docker_credentials" {
  description = "Docker credentials for the registry"
  value       = digitalocean_container_registry_docker_credentials.main.docker_credentials
  sensitive   = true
}
