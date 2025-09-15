# Load Balancer Module Outputs

output "lb_id" {
  description = "ID of the load balancer"
  value       = digitalocean_loadbalancer.main.id
}

output "lb_name" {
  description = "Name of the load balancer"
  value       = digitalocean_loadbalancer.main.name
}

output "lb_ip" {
  description = "Public IP address of the load balancer"
  value       = digitalocean_loadbalancer.main.ip
}

output "lb_status" {
  description = "Status of the load balancer"
  value       = digitalocean_loadbalancer.main.status
}

output "lb_algorithm" {
  description = "Load balancing algorithm"
  value       = digitalocean_loadbalancer.main.algorithm
}

output "lb_region" {
  description = "Region of the load balancer"
  value       = digitalocean_loadbalancer.main.region
}
