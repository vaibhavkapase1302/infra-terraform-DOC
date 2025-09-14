# DigitalOcean Kubernetes (DOKS) module
# This module creates a DigitalOcean Kubernetes cluster

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Create DigitalOcean Kubernetes cluster
resource "digitalocean_kubernetes_cluster" "main" {
  name    = var.cluster_name
  region  = var.region
  version = "1.33.1-do.3"  # Latest available version from doctl
  
  # Node pool configuration
  node_pool {
    name       = "${var.cluster_name}-pool"
    size       = var.node_size
    node_count = var.node_count
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
    
    # Add tags to nodes
    tags = var.tags
  }
  
  # Enable auto-upgrade for the cluster
  auto_upgrade = true
  
  # Enable maintenance window
  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }
}
