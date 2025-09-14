# DigitalOcean Infrastructure - Terraform

This repository contains Terraform configurations for provisioning infrastructure on DigitalOcean, including a Kubernetes cluster, Container Registry, and VPC networking.

## 🏗️ Infrastructure Components

- **DigitalOcean Kubernetes (DOKS) Cluster**: Managed Kubernetes cluster for containerized applications
- **DigitalOcean Container Registry**: For storing Docker images  
- **VPC and Networking**: Virtual Private Cloud with secure networking
- **Modular Architecture**: Well-organized Terraform modules for maintainability

## 📁 Project Structure

```
infra-terraform-DOC/
├── backend.tf                    # Terraform backend configuration
├── main.tf                      # Main Terraform configuration
├── providers.tf                  # Provider configurations
├── variables.tf                  # Input variables
├── outputs.tf                    # Output values
├── modules/                      # Terraform modules
│   ├── k8s-doks/                # Kubernetes cluster module
│   ├── img-registry/            # Container registry module
│   └── networking/              # Networking module
├── envs/                        # Environment-specific configurations
│   └── dev/
│       └── infra.tfvars
├── deploy.sh                    # Infrastructure deployment script
├── migrate-to-spaces.sh         # State migration to DigitalOcean Spaces
└── README.md                    # This file
```

## 🚀 Quick Start

### 1. Prerequisites

- DigitalOcean account with API access
- Terraform (version >= 1.0)
- DigitalOcean API token

### 2. Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd infra-terraform-DOC

# Set your DigitalOcean API token
export DO_TOKEN="your_digitalocean_api_token_here"

# Or create terraform.tfvars file
echo 'do_token = "your_digitalocean_api_token_here"' > terraform.tfvars
```

### 3. Deploy Infrastructure

```bash
# Quick deployment
./deploy.sh

# Or manual deployment
terraform init
terraform plan -var-file="envs/dev/infra.tfvars"
terraform apply -var-file="envs/dev/infra.tfvars"
```

## 📋 Infrastructure Details

### Current Deployment
- **Kubernetes Cluster**: `flask-app-dev-cluster` (2 nodes)
- **Container Registry**: `flask-app-dev-registry`
- **VPC**: `flask-app-dev-vpc-nyc3` (IP: 10.30.0.0/16)
- **Region**: `nyc3`

### State Management
- **Current**: Local backend (`terraform.tfstate`)
- **Optional**: Migrate to DigitalOcean Spaces using `./migrate-to-spaces.sh`

## 🔍 Usage

### Access Kubernetes Cluster

```bash
# Get kubeconfig
terraform output -raw kubeconfig > kubeconfig.yaml
export KUBECONFIG=./kubeconfig.yaml

# Verify cluster access
kubectl get nodes
```

### Push Docker Images

```bash
# Login to registry
doctl registry login

# Tag and push image
docker tag your-app:latest registry.digitalocean.com/flask-app-dev-registry/your-app:latest
docker push registry.digitalocean.com/flask-app-dev-registry/your-app:latest
```

## 🧹 Cleanup

```bash
# Destroy all resources
terraform destroy -var-file="envs/dev/infra.tfvars"
```

**⚠️ Warning**: This will permanently delete all resources and data.

## 🔧 State Migration to DigitalOcean Spaces

To migrate from local state to DigitalOcean Spaces:

1. Create DigitalOcean Spaces access keys
2. Set environment variables:
   ```bash
   export AWS_ACCESS_KEY_ID="your_spaces_access_key"
   export AWS_SECRET_ACCESS_KEY="your_spaces_secret_key"
   ```
3. Run migration script:
   ```bash
   ./migrate-to-spaces.sh
   ```

## 📚 Resources

- [DigitalOcean Terraform Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)
- [DigitalOcean Kubernetes Documentation](https://docs.digitalocean.com/products/kubernetes/)
- [DigitalOcean Container Registry](https://docs.digitalocean.com/products/container-registry/)