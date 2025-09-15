# Development environment configuration
# This file contains variable values for the dev environment

# Environment configuration
environment = "dev"

# Region configuration
region = "nyc3"  # Changed to nyc3 for container registry support

# Kubernetes cluster configuration
k8s_cluster_name = "flask-app-dev-cluster"
k8s_node_size    = "s-4vcpu-8gb"  # Smallest size for development
k8s_node_count   = 3

# Container Registry configuration
registry_name = "flask-app-dev-registry"

# Networking configuration
vpc_name   = "flask-app-dev-vpc-nyc3"  # Changed name to avoid conflict
vpc_region = "nyc3"  # Changed to nyc3 to match region

# Tags for all resources
tags = ["terraform", "flask-app", "dev", "devops", "hiring-task"]

app_hostname = "kubetux.com"
root_domain  = "kubetux.com"
additional_domains = ["www.kubetux.com"]
letsencrypt_email = "vaibhavkapase132@gmail.com"