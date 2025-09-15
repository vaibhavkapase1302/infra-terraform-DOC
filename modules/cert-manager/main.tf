terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "cert_manager" {
  name       = var.release_name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  version    = var.chart_version

  values = [yamlencode({
    installCRDs = true
  })]

  timeout         = 600
  cleanup_on_fail = true
  atomic          = true

  depends_on = [kubernetes_namespace.cert_manager]
}

# Ensure CRDs are registered before creating ClusterIssuer
resource "time_sleep" "wait_for_crds" {
  create_duration = "30s"

  depends_on = [helm_release.cert_manager]
}

resource "kubernetes_manifest" "letsencrypt_cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = var.cluster_issuer_name
    }
    spec = {
      acme = {
        email  = var.email
        server = var.acme_server
        privateKeySecretRef = {
          name = var.cluster_issuer_name
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [helm_release.cert_manager, time_sleep.wait_for_crds]
  count = var.create_cluster_issuer ? 1 : 0
}

