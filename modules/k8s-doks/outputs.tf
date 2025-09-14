# Outputs for the Kubernetes cluster module

output "cluster_id" {
  description = "ID of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.id
}

output "cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.endpoint
}

output "cluster_token" {
  description = "Token for the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.kube_config[0].token
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "CA certificate of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_version" {
  description = "Version of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.version
}

output "cluster_region" {
  description = "Region of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.region
}

output "cluster_status" {
  description = "Status of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.main.status
}
