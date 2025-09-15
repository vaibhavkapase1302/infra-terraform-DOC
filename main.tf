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

# DigitalOcean Load Balancer module
module "load_balancer" {
  source = "./modules/load-balancer"
  
  lb_name          = var.lb_name
  region           = var.region
  k8s_cluster_name = var.k8s_cluster_name
  ssl_certificate_id = var.ssl_certificate_id
  health_check_path = var.health_check_path
  
  depends_on = [module.k8s_doks]
}
