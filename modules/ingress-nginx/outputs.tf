output "controller_service_name" {
  value       = "${helm_release.ingress_nginx.name}-controller"
  description = "Name of the ingress-nginx controller service"
}

output "namespace" {
  value       = var.namespace
  description = "Namespace where ingress-nginx is installed"
}

