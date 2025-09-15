# DigitalOcean Load Balancer Module
# This creates a load balancer for the Kubernetes cluster

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Get the Kubernetes cluster nodes
data "digitalocean_kubernetes_cluster" "main" {
  name = var.k8s_cluster_name
}

# Create Load Balancer
resource "digitalocean_loadbalancer" "main" {
  name   = var.lb_name
  region = var.region
  
  # HTTP forwarding rule
  forwarding_rule {
    entry_protocol  = "http"
    entry_port      = 80
    target_protocol = "http"
    target_port     = 80
  }
  
  # HTTPS forwarding rule (if SSL certificate is provided)
  dynamic "forwarding_rule" {
    for_each = var.ssl_certificate_id != null ? [1] : []
    content {
      entry_protocol  = "https"
      entry_port       = 443
      target_protocol  = "http"
      target_port      = 80
      certificate_name = var.ssl_certificate_id
    }
  }
  
  # Health check
  healthcheck {
    protocol               = "http"
    port                   = 80
    path                   = var.health_check_path
    check_interval_seconds = var.health_check_interval
    response_timeout_seconds = var.health_check_timeout
    unhealthy_threshold    = var.health_check_unhealthy_threshold
    healthy_threshold      = var.health_check_healthy_threshold
  }
  
  # Attach to Kubernetes cluster nodes
  droplet_ids = data.digitalocean_kubernetes_cluster.main.node_pool[0].nodes[*].droplet_id
}
