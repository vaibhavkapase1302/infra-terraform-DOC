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
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true",
      "cert-manager.io/cluster-issuer"            = var.cluster_issuer
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

    tls {
      hosts       = [var.host]
      secret_name = var.tls_secret_name
    }
  }
}

output "ingress_name" {
  value       = kubernetes_ingress_v1.app.metadata[0].name
  description = "Name of the created ingress"
}

