variable "name" {
  type        = string
  description = "Ingress name"
  default     = "flask-app-ingress"
}

variable "namespace" {
  type        = string
  description = "Namespace where the Service lives"
  default     = "flask"
}

variable "host" {
  type        = string
  description = "Host for the ingress (e.g., www.kubetux.com)"
}

variable "service_name" {
  type        = string
  description = "Backend Service name"
  default     = "flask-app-service"
}

variable "service_port" {
  type        = number
  description = "Backend Service port"
  default     = 80
}

variable "tls_secret_name" {
  type        = string
  description = "TLS secret name for cert-manager to store the certificate"
  default     = "kubetux-com-tls"
}

variable "cluster_issuer" {
  type        = string
  description = "cert-manager ClusterIssuer name"
  default     = "letsencrypt-prod"
}

variable "annotations" {
  type        = map(string)
  description = "Additional ingress annotations"
  default     = {}
}

