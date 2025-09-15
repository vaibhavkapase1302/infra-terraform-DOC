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

# Ingress Controller outputs
output "ingress_controller_service_name" {
  description = "Name of the ingress-nginx controller Service"
  value       = module.ingress_nginx.controller_service_name
}

output "ingress_controller_namespace" {
  description = "Namespace of the ingress-nginx controller"
  value       = module.ingress_nginx.namespace
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
