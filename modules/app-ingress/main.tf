terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

resource "kubernetes_ingress_v1" "app" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = merge({
      "kubernetes.io/ingress.class"               = "nginx",
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }, var.annotations)
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = var.host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = var.service_name
              port {
                number = var.service_port
              }
            }
          }
        }
      }
    }

    # TLS terminated at DO Load Balancer, so no tls section here
  }
}

output "ingress_name" {
  value       = kubernetes_ingress_v1.app.metadata[0].name
  description = "Name of the created ingress"
}

