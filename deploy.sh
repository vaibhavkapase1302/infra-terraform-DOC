#!/bin/bash

# DigitalOcean Infrastructure Deployment Script
# Quick deployment of Kubernetes cluster, Container Registry, and VPC

set -e

echo "🚀 DigitalOcean Infrastructure Deployment"
echo "========================================"

# Check prerequisites
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform not found. Install from: https://www.terraform.io/downloads.html"
    exit 1
fi

if [ -z "$DO_TOKEN" ]; then
    echo "❌ DO_TOKEN not set. Please set your DigitalOcean API token:"
    echo "   export DO_TOKEN='your_digitalocean_api_token_here'"
    exit 1
fi

echo "✅ Prerequisites check passed"
echo ""

# Initialize and validate
echo "🔧 Initializing Terraform..."
terraform init

echo "🔍 Validating configuration..."
terraform validate

# Plan deployment
echo "📋 Planning deployment..."
terraform plan -var-file="envs/dev/infra.tfvars"

# Confirm deployment
echo ""
read -p "🤔 Deploy infrastructure? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

# Deploy
echo "🚀 Deploying infrastructure..."
terraform apply -var-file="envs/dev/infra.tfvars" -auto-approve

# Show results
echo ""
echo "✅ Deployment completed successfully!"
echo ""
echo "📊 Infrastructure Outputs:"
echo "========================"
terraform output

echo ""
echo "🔧 Next Steps:"
echo "=============="
echo "1. Get kubeconfig: terraform output -raw kubeconfig > kubeconfig.yaml"
echo "2. Set KUBECONFIG: export KUBECONFIG=./kubeconfig.yaml"
echo "3. Verify cluster: kubectl get nodes"
echo "4. Push images: doctl registry login"
echo ""
echo "📚 For more info, see README.md"