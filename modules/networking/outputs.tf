# Outputs for the networking module

output "vpc_id" {
  description = "ID of the VPC"
  value       = digitalocean_vpc.main.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = digitalocean_vpc.main.name
}

output "vpc_ip_range" {
  description = "IP range of the VPC"
  value       = digitalocean_vpc.main.ip_range
}
