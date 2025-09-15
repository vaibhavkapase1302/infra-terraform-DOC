variable "namespace" {
  type        = string
  description = "Namespace for cert-manager"
  default     = "cert-manager"
}

variable "release_name" {
  type        = string
  description = "Helm release name for cert-manager"
  default     = "cert-manager"
}

variable "chart_version" {
  type        = string
  description = "Chart version for cert-manager"
  default     = "v1.14.2"
}

variable "email" {
  type        = string
  description = "Email for Let's Encrypt account"
}

variable "cluster_issuer_name" {
  type        = string
  description = "ClusterIssuer name"
  default     = "letsencrypt-prod"
}

variable "acme_server" {
  type        = string
  description = "ACME server URL"
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "create_cluster_issuer" {
  type        = bool
  description = "Whether to create the ClusterIssuer in this apply"
  default     = true
}
