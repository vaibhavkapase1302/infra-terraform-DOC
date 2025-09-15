#!/bin/bash

# Flask Application Deployment Script
# This script deploys the Flask application to the Kubernetes cluster

set -e

echo "🚀 Flask Application Deployment"
echo "=============================="

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl first."
    echo "   Visit: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
    exit 1
fi

# Check if kubeconfig is set
if [ -z "$KUBECONFIG" ]; then
    echo "❌ KUBECONFIG not set. Please set it first:"
    echo "   export KUBECONFIG=./kubeconfig.yaml"
    exit 1
fi

# Verify cluster access
echo "🔍 Verifying cluster access..."
if ! kubectl get nodes > /dev/null 2>&1; then
    echo "❌ Cannot access Kubernetes cluster. Please check your kubeconfig."
    exit 1
fi

echo "✅ Cluster access verified"
echo ""

echo "ℹ️ Skipping NGINX Ingress install: managed by Terraform Helm modules (ingress-nginx, cert-manager, app-ingress)."
echo ""

# Deploy Flask Application (only Deployment and Service; Ingress is Terraform-managed)
echo "📦 Deploying Flask Application..."
kubectl apply -f k8s-manifests/flask-app-deployment.yaml
kubectl apply -f k8s-manifests/flask-app-service.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for Flask Application to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/flask-app

# Show deployment status
echo "📊 Deployment Status:"
echo "===================="
kubectl get pods -l app=flask-app -o wide
kubectl get svc -n ingress-nginx ingress-nginx-controller -o wide || true
kubectl get services
kubectl get ingress -o wide

# Helpful curl hint
echo ""
echo "🔧 Next Steps:"
echo "=============="
echo "1. Get Load Balancer IP (Ingress Controller): kubectl get svc -n ingress-nginx ingress-nginx-controller -o wide"

LB_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)
if [ -n "$LB_IP" ]; then
  echo "2. Test via IP (host header): curl -H 'Host: www.kubetux.com' http://$LB_IP/"
fi

echo "3. After DNS propagates: curl -v http://www.kubetux.com/"
echo ""
echo "📚 For more info, see REQUEST_FLOW_DIAGRAM.md"
