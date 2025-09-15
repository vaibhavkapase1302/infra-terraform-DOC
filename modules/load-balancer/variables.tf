# Load Balancer Module Variables

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "flask-app-lb"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
}

variable "k8s_cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "ssl_certificate_id" {
  description = "SSL certificate ID for HTTPS (optional)"
  type        = string
  default     = null
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/health"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 10
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_unhealthy_threshold" {
  description = "Number of failed health checks before marking unhealthy"
  type        = number
  default     = 3
}

variable "health_check_healthy_threshold" {
  description = "Number of successful health checks before marking healthy"
  type        = number
  default     = 2
}

