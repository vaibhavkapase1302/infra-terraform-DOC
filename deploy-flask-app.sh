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

# Deploy NGINX Ingress Controller
echo "📦 Deploying NGINX Ingress Controller..."
kubectl apply -f k8s-manifests/nginx-ingress-controller.yaml

# Wait for ingress controller to be ready
echo "⏳ Waiting for NGINX Ingress Controller to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/nginx-ingress-controller -n kube-system

echo "✅ NGINX Ingress Controller deployed"
echo ""

# Deploy Flask Application
echo "📦 Deploying Flask Application..."
kubectl apply -f k8s-manifests/flask-app-deployment.yaml
kubectl apply -f k8s-manifests/flask-app-service.yaml
kubectl apply -f k8s-manifests/flask-app-ingress.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for Flask Application to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/flask-app

echo "✅ Flask Application deployed"
echo ""

# Show deployment status
echo "📊 Deployment Status:"
echo "===================="
kubectl get pods -l app=flask-app
kubectl get services
kubectl get ingress

echo ""
echo "🔧 Next Steps:"
echo "=============="
echo "1. Get Load Balancer IP: terraform output lb_ip"
echo "2. Update DNS: Point www.kubetux.com to Load Balancer IP"
echo "3. Test: curl http://www.kubetux.com"
echo ""
echo "📚 For more info, see REQUEST_FLOW_DIAGRAM.md"
