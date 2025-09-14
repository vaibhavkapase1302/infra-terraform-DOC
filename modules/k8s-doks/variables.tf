# Variables for the Kubernetes cluster module

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
}

variable "node_size" {
  description = "Size of Kubernetes nodes"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the Kubernetes cluster"
  type        = number
}

variable "vpc_id" {
  description = "ID of the VPC to use for the cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = list(string)
  default     = []
}
