# Flask Application Request Flow: kubetux.com → Pod (HTTPS)

## Request Flow Diagram

```
Internet User
     │
     │ 1. DNS Lookup: kubetux.com
     │
     ▼
┌─────────────────┐
│   DO DNS (A)    │ kubetux.com → 159.89.254.27
└─────────────────┘
     │
     │ 2. HTTPS Request
     │
     ▼
┌───────────────────────────────────────┐
│  ingress-nginx Service (LoadBalancer) │ Public IP: 159.89.254.27
└───────────────────────────────────────┘
     │
     │ 3. Ingress Controller (NGINX)
     │    - Terminates TLS using cert from cert-manager
     │    - Enforces HTTP→HTTPS redirect
     ▼
┌─────────────────────────────────┐
│  Ingress: host kubetux.com      │ → backend: flask-app-service:80
└─────────────────────────────────┘
     │
     │ 4. Service (ClusterIP)
     ▼
┌─────────────────────────────────┐
│  flask-app-service :80 → :5000  │
└─────────────────────────────────┘
     │
     │ 5. Pod(s)
     ▼
┌─────────────────────────────────┐
│  flask-app Deployment           │ Image: DOCR
└─────────────────────────────────┘
```

## Components (as deployed)

### 1) Ingress Controller via Helm (Terraform)
- Module: `modules/ingress-nginx`
- Creates Service `ingress-nginx-controller` type `LoadBalancer`

### 2) cert-manager via Helm (Terraform)
- Module: `modules/cert-manager`
- Installs CRDs and creates `ClusterIssuer/letsencrypt-prod`

### 3) App Ingress (Terraform)
- Module: `modules/app-ingress`
- Host: `kubetux.com`, TLS secret: `kubetux-com-tls`, issuer: `letsencrypt-prod`

### 4) Service (YAML manifest)
- `k8s-manifests/flask-app-service.yaml` type `ClusterIP`

### 5) Deployment (YAML manifest)
- `k8s-manifests/flask-app-deployment.yaml` uses image from DOCR
- References `imagePullSecrets: registry-flask-app-dev-registry`

## End-to-End Steps

1. Set DNS A record: `kubetux.com` → ingress public IP
2. Terraform installs ingress-nginx and cert-manager
3. Terraform creates ClusterIssuer `letsencrypt-prod`
4. Terraform creates Ingress for `kubetux.com` with TLS
5. cert-manager completes HTTP-01 and issues certificate
6. NGINX serves HTTPS and redirects HTTP→HTTPS

## Verification

```bash
kubectl -n ingress-nginx get svc ingress-nginx-controller
kubectl -n flask get ingress,certificate
curl -I http://kubetux.com       # 308 to https
curl -I https://kubetux.com      # 200 OK
```
