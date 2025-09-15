variable "name" {
  type        = string
  description = "Certificate resource name in DO"
  default     = "kubetux-com-cert"
}

variable "root_domain" {
  type        = string
  description = "Root domain (e.g., kubetux.com)"
}

variable "hostname" {
  type        = string
  description = "Primary hostname (e.g., www.kubetux.com)"
}

variable "additional_domains" {
  type        = list(string)
  description = "Additional SANs"
  default     = []
}

