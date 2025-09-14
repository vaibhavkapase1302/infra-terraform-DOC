# Variables for the container registry module

variable "registry_name" {
  description = "Name of the DigitalOcean Container Registry"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = list(string)
  default     = []
}
