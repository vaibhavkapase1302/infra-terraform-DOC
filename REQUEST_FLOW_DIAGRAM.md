# Flask Application Request Flow: www.kubetux.com → Pod

## Request Flow Diagram

```
Internet User
     │
     │ 1. DNS Lookup: www.kubetux.com
     │
     ▼
┌─────────────────┐
│   DNS Provider   │ ← External DNS (Cloudflare, Route53, etc.)
│  (kubetux.com)  │
└─────────────────┘
     │
     │ 2. DNS resolves to Load Balancer IP
     │
     ▼
┌─────────────────────────────────┐
│     DigitalOcean Load Balancer   │ ← NEW: Need to add this
│     (External IP: 157.245.x.x)  │
└─────────────────────────────────┘
     │
     │ 3. HTTP/HTTPS Request
     │
     ▼
┌─────────────────────────────────┐
│     DigitalOcean Kubernetes     │
│     Cluster (DOKS)              │ ← EXISTING: You have this
└─────────────────────────────────┘
     │
     │ 4. Ingress Controller
     │
     ▼
┌─────────────────────────────────┐
│     NGINX Ingress Controller     │ ← NEW: Need to add this
│     (Pod in kube-system)         │
└─────────────────────────────────┘
     │
     │ 5. Route based on Host header
     │
     ▼
┌─────────────────────────────────┐
│     Kubernetes Ingress          │ ← NEW: Need to add this
│     (Ingress Resource)           │
└─────────────────────────────────┘
     │
     │ 6. Service Discovery
     │
     ▼
┌─────────────────────────────────┐
│     Kubernetes Service           │ ← NEW: Need to add this
│     (ClusterIP Service)          │
└─────────────────────────────────┘
     │
     │ 7. Load Balance to Pods
     │
     ▼
┌─────────────────────────────────┐
│     Flask Application Pods      │ ← NEW: Need to add this
│     (Your Flask App)             │
└─────────────────────────────────┘
```

## Infrastructure Components Needed

### 1. DigitalOcean Load Balancer
```hcl
resource "digitalocean_loadbalancer" "main" {
  name   = "flask-app-lb"
  region = "nyc3"
  
  forwarding_rule {
    entry_protocol  = "http"
    entry_port      = 80
    target_protocol  = "http"
    target_port      = 80
  }
  
  forwarding_rule {
    entry_protocol  = "https"
    entry_port      = 443
    target_protocol  = "http"
    target_port      = 80
  }
  
  healthcheck {
    protocol               = "http"
    port                   = 80
    path                   = "/health"
    check_interval_seconds = 10
    response_timeout_seconds = 5
    unhealthy_threshold    = 3
    healthy_threshold      = 2
  }
  
  droplet_ids = [digitalocean_droplet.ingress_controller.id]
}
```

### 2. NGINX Ingress Controller
```yaml
# nginx-ingress-controller.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ingress-controller
  namespace: kube-system
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-ingress-controller
  template:
    metadata:
      labels:
        app: nginx-ingress-controller
    spec:
      containers:
      - name: nginx-ingress-controller
        image: nginx/nginx-ingress:2.4.2
        ports:
        - containerPort: 80
        - containerPort: 443
        env:
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
```

### 3. Kubernetes Ingress
```yaml
# flask-app-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: flask-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: www.kubetux.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: flask-app-service
            port:
              number: 80
```

### 4. Kubernetes Service
```yaml
# flask-app-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: flask-app-service
spec:
  selector:
    app: flask-app
  ports:
  - port: 80
    targetPort: 5000
  type: ClusterIP
```

### 5. Flask Application Deployment
```yaml
# flask-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask-app
        image: registry.digitalocean.com/flask-app-dev-registry/flask-app:latest
        ports:
        - containerPort: 5000
        env:
        - name: FLASK_ENV
          value: "production"
```

## Complete Request Flow Steps

1. **User types www.kubetux.com** → DNS lookup
2. **DNS resolves to Load Balancer IP** → 157.245.x.x
3. **Load Balancer receives request** → Routes to healthy nodes
4. **NGINX Ingress Controller** → Processes request
5. **Ingress Resource** → Routes based on Host header
6. **Kubernetes Service** → Load balances to pods
7. **Flask Pod** → Processes request and returns response
8. **Response flows back** → Through same path

## What You Need to Add to Terraform

### Current Infrastructure (You Have):
- ✅ DigitalOcean Kubernetes Cluster
- ✅ DigitalOcean Container Registry
- ✅ VPC Networking

### Missing Infrastructure (Need to Add):
- ❌ DigitalOcean Load Balancer
- ❌ NGINX Ingress Controller (Kubernetes manifest)
- ❌ Ingress Resource (Kubernetes manifest)
- ❌ Service Resource (Kubernetes manifest)
- ❌ Flask App Deployment (Kubernetes manifest)
- ❌ DNS Configuration (External)

## Next Steps for Implementation

1. **Add Load Balancer to Terraform**
2. **Create Kubernetes manifests for ingress controller**
3. **Create Flask app deployment manifests**
4. **Configure DNS to point to Load Balancer**
5. **Deploy and test the complete flow**

This gives you a complete production-ready setup for your Flask application!
