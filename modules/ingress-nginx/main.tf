terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

resource "helm_release" "ingress_nginx" {
  name       = var.release_name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.namespace
  version    = var.chart_version
  create_namespace = true

  values = [yamlencode({
    controller = {
      service = {
        type = "LoadBalancer"
        annotations = merge(var.service_annotations,
          var.do_certificate_id != "" ? {
            "service.beta.kubernetes.io/do-loadbalancer-certificate-id" = var.do_certificate_id,
            "service.beta.kubernetes.io/do-loadbalancer-protocol"      = "https",
            "service.beta.kubernetes.io/do-loadbalancer-redirect-http-to-https" = "true"
          } : {}
        )
        ports = {
          http  = 80
          https = 443
        }
        targetPorts = {
          http  = "http"
          https = "https"
        }
      }
      replicaCount = var.replica_count
    }
  })]

  timeout          = 600
  cleanup_on_fail  = true
  recreate_pods    = true
  atomic           = true
  dependency_update = true

  # Namespace is created by Helm; the root module enforces dependency on the cluster
}

