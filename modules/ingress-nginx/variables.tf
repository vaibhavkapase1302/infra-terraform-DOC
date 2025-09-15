variable "namespace" {
  type        = string
  description = "Namespace for ingress-nginx"
  default     = "ingress-nginx"
}

variable "release_name" {
  type        = string
  description = "Helm release name"
  default     = "ingress-nginx"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version for ingress-nginx"
  default     = "4.11.2"
}

variable "replica_count" {
  type        = number
  description = "Number of controller replicas"
  default     = 2
}

variable "service_annotations" {
  type        = map(string)
  description = "Annotations to add to the controller Service"
  default     = {}
}

variable "do_certificate_id" {
  type        = string
  description = "DigitalOcean certificate ID to terminate TLS at the LB"
  default     = ""
}

