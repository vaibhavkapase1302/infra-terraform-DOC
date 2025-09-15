# Output values for the infrastructure

# Kubernetes cluster outputs
output "k8s_cluster_id" {
  description = "ID of the Kubernetes cluster"
  value       = module.k8s_doks.cluster_id
}

output "k8s_cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = module.k8s_doks.cluster_name
}

output "k8s_cluster_endpoint" {
  description = "Endpoint of the Kubernetes cluster"
  value       = module.k8s_doks.cluster_endpoint
}

output "k8s_cluster_token" {
  description = "Token for the Kubernetes cluster"
  value       = module.k8s_doks.cluster_token
  sensitive   = true
}

output "k8s_cluster_ca_certificate" {
  description = "CA certificate of the Kubernetes cluster"
  value       = module.k8s_doks.cluster_ca_certificate
  sensitive   = true
}

# Container Registry outputs
output "registry_name" {
  description = "Name of the DigitalOcean Container Registry"
  value       = module.img_registry.registry_name
}

output "registry_endpoint" {
  description = "Endpoint of the DigitalOcean Container Registry"
  value       = module.img_registry.registry_endpoint
}

output "registry_server" {
  description = "Server URL of the DigitalOcean Container Registry"
  value       = module.img_registry.registry_server
}

# Networking outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = module.networking.vpc_name
}

# Load Balancer outputs
output "lb_id" {
  description = "ID of the load balancer"
  value       = module.load_balancer.lb_id
}

output "lb_name" {
  description = "Name of the load balancer"
  value       = module.load_balancer.lb_name
}

output "lb_ip" {
  description = "Public IP address of the load balancer"
  value       = module.load_balancer.lb_ip
}

output "lb_status" {
  description = "Status of the load balancer"
  value       = module.load_balancer.lb_status
}

# Kubeconfig for local kubectl access
output "kubeconfig" {
  description = "Kubeconfig content for kubectl access"
  value = yamlencode({
    apiVersion = "v1"
    kind       = "Config"
    clusters = [{
      name    = module.k8s_doks.cluster_name
      cluster = {
        server                   = module.k8s_doks.cluster_endpoint
        "certificate-authority-data" = module.k8s_doks.cluster_ca_certificate
      }
    }]
    users = [{
      name = module.k8s_doks.cluster_name
      user = {
        token = module.k8s_doks.cluster_token
      }
    }]
    contexts = [{
      name = module.k8s_doks.cluster_name
      context = {
        cluster = module.k8s_doks.cluster_name
        user    = module.k8s_doks.cluster_name
      }
    }]
    "current-context" = module.k8s_doks.cluster_name
  })
  sensitive = true
}
