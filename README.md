# DigitalOcean Infrastructure with Terraform

This is a Terraform project I built on DigitalOcean. It provisions a complete infrastructure setup on DigitalOcean including a Kubernetes cluster, container registry, and VPC networking - all ready for deploying containerized applications.

## What This Creates

When you run this Terraform configuration, it will set up:

- **Kubernetes Cluster**: A 2-node DOKS cluster running in NYC3
- **Container Registry**: A private registry for storing Docker images
- **VPC Network**: Isolated networking with custom IP ranges
- **All the connections**: Everything is wired together and ready to use

## Project Structure

```
infra-terraform-DOC/
├── backend.tf                    # How Terraform stores its state
├── main.tf                      # Main configuration that ties everything together
├── providers.tf                  # DigitalOcean and Kubernetes providers
├── variables.tf                  # Input variables and their types
├── outputs.tf                    # What gets returned after deployment
├── deploy.sh                    # One-command deployment script
├── migrate-to-spaces.sh         # Optional: move state to DigitalOcean Spaces
├── terraform.tfvars             # My actual configuration values
├── modules/                     # Reusable Terraform modules
│   ├── k8s-doks/               # Kubernetes cluster module
│   ├── img-registry/           # Container registry module
│   └── networking/             # VPC and networking module
└── envs/dev/infra.tfvars       # Environment-specific settings
```

## Quick Start

### Prerequisites

You'll need:
- A DigitalOcean account (I'm using the free tier)
- Terraform installed (I used version 1.6+)
- A DigitalOcean API token with read/write permissions

### Get Your API Token

1. Go to [DigitalOcean API Tokens](https://cloud.digitalocean.com/account/api/tokens)
2. Generate a new token
3. Copy it - you'll need it in a minute

### Deploy Everything

```bash
# Set your API token
export DO_TOKEN="your_token_here"

# Run the deployment script
./deploy.sh
```

That's it! The script will initialize Terraform, plan the deployment, ask for confirmation, and then create all the resources.

## What Gets Created

### Kubernetes Cluster
- **Name**: `flask-app-dev-cluster`
- **Nodes**: 2x `s-1vcpu-2gb` (the smallest size for cost efficiency)
- **Region**: NYC3
- **Auto-scaling**: Not enabled (keeping it simple for now)

### Container Registry
- **Name**: `flask-app-dev-registry`
- **Tier**: Starter (free 500MB)
- **Endpoint**: `registry.digitalocean.com/flask-app-dev-registry`

### VPC Network
- **Name**: `flask-app-dev-vpc-nyc3`
- **IP Range**: `10.30.0.0/16`
- **Region**: NYC3

## Using Your Infrastructure

### Connect to Kubernetes

```bash
# Get the kubeconfig file
terraform output -raw kubeconfig > kubeconfig.yaml

# Tell kubectl to use it
export KUBECONFIG=./kubeconfig.yaml

# Check that it works
kubectl get nodes
```

You should see your 2 nodes listed and ready.

### Push Docker Images

```bash
# Login to the registry
doctl registry login

# Tag your image
docker tag my-app:latest registry.digitalocean.com/flask-app-dev-registry/my-app:latest

# Push it
docker push registry.digitalocean.com/flask-app-dev-registry/my-app:latest
```

## State Management

Right now, Terraform stores its state locally in `terraform.tfstate`. This works fine for solo development, but if you want to:

- Work with a team
- Store state remotely
- Have automatic backups

You can migrate to DigitalOcean Spaces using the included script:

```bash
# First, get Spaces access keys from DigitalOcean
# Go to: https://cloud.digitalocean.com/account/api/spaces
# Generate new key and copy the Access Key and Secret Key

# Run the migration script - it will guide you through the process
./migrate-to-spaces.sh
```

## Customization

### Change Node Size

Edit `envs/dev/infra.tfvars`:
```hcl
k8s_node_size = "s-2vcpu-4gb"  # Upgrade to 2 vCPU, 4GB RAM
```

### Add More Nodes

```hcl
k8s_node_count = 3  # Add a third node
```

### Different Region

```hcl
region = "sfo3"  # San Francisco instead of NYC
```

## Cleanup

When you're done testing:

```bash
terraform destroy -var-file="envs/dev/infra.tfvars"
```

This will delete everything and stop the billing. The Kubernetes cluster is the most expensive part, so destroying it will save you money.

## Troubleshooting

### "InvalidAccessKeyId" Error
This usually means your `DO_TOKEN` isn't set or is wrong. Double-check it.

### "Resource already exists" Error
You might have created resources with the same name before. Either:
- Change the names in `envs/dev/infra.tfvars`
- Or destroy the existing resources first

### "VPC range overlaps" Error
The IP range `10.30.0.0/16` might conflict with an existing VPC. Try changing it in the networking module.

## Why I Built It This Way

- **Modular**: Each component (K8s, registry, networking) is in its own module
- **Environment-specific**: Easy to add staging/prod environments later
- **Cost-conscious**: Using the smallest node sizes and free registry tier
- **Simple**: No complex networking or advanced features - just what's needed

---
