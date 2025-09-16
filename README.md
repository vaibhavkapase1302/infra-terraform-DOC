# DigitalOcean Kubernetes + Ingress + TLS (Terraform)

This repo provisions a production-ready path to run a Flask app on DigitalOcean Kubernetes (DOKS) behind NGINX Ingress with automatic HTTPS via cert-manager and Let’s Encrypt. It also creates a DigitalOcean Container Registry (DOCR) and a VPC.

## What This Creates

When you apply this configuration, it sets up:

- **DOKS Cluster**: Managed Kubernetes in `nyc3` with your desired node size/count
- **VPC Network**: Isolated networking for the cluster
- **DO Container Registry**: Private registry for app images
- **Ingress-NGINX (Helm)**: Ingress controller with a public LoadBalancer
- **cert-manager (Helm) + ClusterIssuer**: Automatic TLS via Let’s Encrypt
- **Kubernetes Ingress**: Host-based routing for `kubetux.com` to your Flask service

## Project Structure

```
infra-terraform-DOC/
├── backend.tf                    # How Terraform stores its state
├── main.tf                      # Orchestrates all modules
├── providers.tf                  # DO, Kubernetes, Helm, Time providers
├── variables.tf                  # Input variables and their types
├── outputs.tf                    # What gets returned after deployment
├── deploy.sh                    # One-command deployment script
├── migrate-to-spaces.sh         # Optional: move state to DigitalOcean Spaces
├── terraform.tfvars             # My actual configuration values
├── modules/                     # Reusable Terraform modules
│   ├── k8s-doks/               # DigitalOcean Kubernetes cluster
│   ├── img-registry/           # DigitalOcean Container Registry
│   ├── networking/             # VPC
│   ├── ingress-nginx/          # Helm release for NGINX Ingress Controller
│   ├── cert-manager/           # Helm release + ClusterIssuer
│   └── app-ingress/            # Kubernetes Ingress for the Flask app
└── envs/dev/infra.tfvars       # Environment-specific settings
```

## Quick Start

### Prerequisites

You'll need:
- A DigitalOcean account
- Terraform >= 1.3 (tested with 1.6+)
- `doctl` and `kubectl` installed
- A DigitalOcean API token with read/write permissions

### Get Your API Token

1. Go to [DigitalOcean API Tokens](https://cloud.digitalocean.com/account/api/tokens)
2. Generate a new token
3. Copy it - you'll need it in a minute

### Deploy Everything

```bash
# Set your API token (required by Terraform DO provider and doctl)
export DO_TOKEN="your_token_here"
doctl auth init -t "$DO_TOKEN"

# Initialize and inspect the plan with your env vars
terraform init -reconfigure
terraform plan -var-file="envs/dev/infra.tfvars"

# Apply
terraform apply -var-file="envs/dev/infra.tfvars"
```

This will create the cluster, ingress controller, cert-manager + ClusterIssuer, and the app Ingress.

## Outputs (useful after apply)

```bash
terraform output
```

- **k8s_cluster_endpoint**: DOKS API endpoint
- **ingress_controller_service_name/namespace**: The ingress Service exposed as LoadBalancer
- Use `kubectl -n ingress-nginx get svc ingress-nginx-controller` to see the public IP

## Using Your Infrastructure

### Connect to Kubernetes

```bash
# Get the kubeconfig and use it
terraform output -raw kubeconfig > kubeconfig.yaml
export KUBECONFIG=./kubeconfig.yaml
kubectl get nodes
```

You should see your nodes listed and Ready.

### Push Docker Images to DOCR

```bash
# Login and push
doctl registry login
docker tag flask-app:v1.0.0-dev registry.digitalocean.com/flask-app-dev-registry/flask-app:v1.0.0-dev
docker push registry.digitalocean.com/flask-app-dev-registry/flask-app:v1.0.0-dev

# Create/refresh the Kubernetes pull secret (default namespace by default)
doctl registry kubernetes-manifest | kubectl apply -f -

# Optional: attach secret to default ServiceAccount so Pods can pull by default
kubectl patch serviceaccount default -p '{"imagePullSecrets":[{"name":"registry-flask-app-dev-registry"}]}' -n flask
```

## DNS and TLS

1. Point your domain `kubetux.com` A record to the Ingress LoadBalancer public IP. Get it via:

```bash
kubectl -n ingress-nginx get svc ingress-nginx-controller
```

2. TLS is handled by cert-manager using the `ClusterIssuer` `letsencrypt-prod`. The app ingress requests a certificate for `kubetux.com` and stores it in the secret `kubetux-com-tls`.

3. Verify:

```bash
kubectl get certificate -n flask
curl -I https://kubetux.com
curl -I http://kubetux.com   # should 308 redirect to https
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
k8s_node_size = "s-4vcpu-8gb"
```

### Add More Nodes

```hcl
k8s_node_count = 3
```

### Different Region

```hcl
region = "nyc3"

### App + TLS variables

```hcl
app_hostname       = "kubetux.com"
root_domain        = "kubetux.com"
additional_domains = ["www.kubetux.com"]
letsencrypt_email  = "you@example.com"
```
```

## Cleanup

When you're done testing:

```bash
terraform destroy -var-file="envs/dev/infra.tfvars"
```

This will delete everything and stop the billing. The Kubernetes cluster is the most expensive part, so destroying it will save you money.

## Troubleshooting

### Image pull 401 Unauthorized
- Ensure the Deployment references `imagePullSecrets: [{ name: registry-flask-app-dev-registry }]`
- Refresh the secret: `doctl registry kubernetes-manifest | kubectl apply -f -`
- Patch the ServiceAccount in the target namespace (e.g., `flask`).

### ClusterIssuer already exists
- If created manually earlier, either import it into state, or delete it and re-apply.

### cert-manager CRDs not ready
- The module waits briefly; if it still fails, re-run `terraform apply`.

### Why `.tfvars` not committed
- `.gitignore` usually excludes `*.tfvars`. Commit an example like `infra.example.tfvars` instead.

## Design Notes

- **Ingress-managed LoadBalancer**: We rely on the ingress-nginx Service of type LoadBalancer; no separate LB module is needed.
- **Helm via Terraform**: Both ingress-nginx and cert-manager are installed via Helm resources.
- **HTTP→HTTPS**: Enforced by Ingress annotation; certs via `ClusterIssuer`.

---
