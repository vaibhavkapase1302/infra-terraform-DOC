terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_certificate" "app" {
  name    = var.name
  type    = "lets_encrypt"
  domains = compact(distinct(concat([var.root_domain, var.hostname], var.additional_domains)))
}

output "certificate_id" {
  value       = digitalocean_certificate.app.id
  description = "ID of the DigitalOcean managed certificate"
}

output "certificate_name" {
  value       = digitalocean_certificate.app.name
  description = "Name of the DigitalOcean managed certificate"
}

