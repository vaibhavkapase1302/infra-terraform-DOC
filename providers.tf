terraform {
  required_version = ">= 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  host  = module.k8s_doks.cluster_endpoint
  token = module.k8s_doks.cluster_token
  cluster_ca_certificate = base64decode(module.k8s_doks.cluster_ca_certificate)
}

# Configure the Helm Provider to talk to the same cluster
provider "helm" {
  kubernetes {
    host                   = module.k8s_doks.cluster_endpoint
    token                  = module.k8s_doks.cluster_token
    cluster_ca_certificate = base64decode(module.k8s_doks.cluster_ca_certificate)
  }
}
