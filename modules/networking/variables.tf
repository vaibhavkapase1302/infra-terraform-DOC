# Variables for the networking module

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_region" {
  description = "Region for the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = list(string)
  default     = []
}
