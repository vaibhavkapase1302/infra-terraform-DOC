# Main Terraform configuration file
# This file orchestrates all the modules and resources

# Networking module - Creates VPC and networking resources
module "networking" {
  source = "./modules/networking"
  
  vpc_name   = var.vpc_name
  vpc_region = var.vpc_region
  tags       = var.tags
}

# DigitalOcean Container Registry module
module "img_registry" {
  source = "./modules/img-registry"
  
  registry_name = var.registry_name
  region        = var.region
  tags          = var.tags
  
  depends_on = [module.networking]
}

# DigitalOcean Kubernetes cluster module
module "k8s_doks" {
  source = "./modules/k8s-doks"
  
  cluster_name = var.k8s_cluster_name
  region       = var.region
  node_size    = var.k8s_node_size
  node_count   = var.k8s_node_count
  vpc_id       = module.networking.vpc_id
  tags         = var.tags
  
  depends_on = [module.networking, module.img_registry]
}

## Ingress NGINX via Helm
module "ingress_nginx" {
  source = "./modules/ingress-nginx"

  namespace       = "ingress-nginx"
  release_name    = "ingress-nginx"
  chart_version   = "4.11.2"
  replica_count   = 2
  service_annotations = {
    # Example: keep LB internal to VPC or set health checks
    # "service.beta.kubernetes.io/do-loadbalancer-enable-backend-keepalive" = "true"
  }
  do_certificate_id = module.do_certificate.certificate_id

  depends_on = [module.k8s_doks]
}

## Application Ingress (no TLS section; TLS terminates at DO LB)
module "app_ingress" {
  source = "./modules/app-ingress"

  host            = var.app_hostname
  service_name    = "flask-app-service"
  service_port    = 80
  tls_secret_name = "" # disabled; TLS at DO LB

  depends_on = [module.ingress_nginx]
}

## DigitalOcean Managed Certificate
module "do_certificate" {
  source = "./modules/do-certificate"

  name              = var.do_cert_name
  root_domain       = var.root_domain
  hostname          = var.app_hostname
  additional_domains = var.additional_domains

  depends_on = [module.k8s_doks]
}
