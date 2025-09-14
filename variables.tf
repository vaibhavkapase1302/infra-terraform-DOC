# DigitalOcean API Token
variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

# Environment name
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Region for DigitalOcean resources
variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

# Kubernetes cluster configuration
variable "k8s_cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "flask-app-cluster"
}

variable "k8s_node_size" {
  description = "Size of Kubernetes nodes"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "k8s_node_count" {
  description = "Number of nodes in the Kubernetes cluster"
  type        = number
  default     = 2
}

# Container Registry configuration
variable "registry_name" {
  description = "Name of the DigitalOcean Container Registry"
  type        = string
  default     = "flask-app-registry"
}

# Networking configuration
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "flask-app-vpc"
}

variable "vpc_region" {
  description = "Region for the VPC"
  type        = string
  default     = "nyc1"
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = list(string)
  default     = ["terraform", "flask-app", "devops"]
}
