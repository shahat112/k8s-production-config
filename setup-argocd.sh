#!/bin/bash

echo "🚀 Setting up GitOps infrastructure with ArgoCD..."

# 1. Get ArgoCD admin password
echo "🔐 Getting ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d 2>/dev/null)
if [ -z "$ARGOCD_PASSWORD" ]; then
    ARGOCD_PASSWORD="admin"
    echo "⚠️  Using default password: admin"
else
    echo "✅ ArgoCD password retrieved"
fi

# 2. Create namespaces
echo "📁 Creating namespaces..."
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -

# 3. Label namespaces for monitoring
echo "🏷️  Labeling namespaces for monitoring..."
kubectl label namespace dev monitoring=enabled --overwrite
kubectl label namespace prod monitoring=enabled --overwrite

# 4. Apply ArgoCD Applications
echo "📦 Applying ArgoCD Applications..."
kubectl apply -f k8s-manifests/applications/demo-app-dev.yaml --namespace=argocd
kubectl apply -f k8s-manifests/applications/demo-app-prod.yaml --namespace=argocd

# 5. Wait for applications to be created
echo "⏳ Waiting for ArgoCD applications to be ready..."
sleep 5

# 6. Display status
echo ""
echo "========================================="
echo "🎉 GitOps Infrastructure Setup Complete!"
echo "========================================="
echo ""
echo "📊 Access URLs:"
echo "  ArgoCD UI:      http://argocd.158.160.206.202.nip.io"
echo "  Grafana:        http://grafana.158.160.206.202.nip.io"
echo "  Prometheus:     http://prometheus.158.160.206.202.nip.io"
echo "  AlertManager:   http://alerts.158.160.206.202.nip.io"
echo ""
echo "👤 ArgoCD Credentials:"
echo "  Username: admin"
echo "  Password: $ARGOCD_PASSWORD"
echo ""
echo "🚀 Application URLs (will be available after sync):"
echo "  Dev:  http://dev.demo-app.158.160.206.202.nip.io"
echo "  Prod: http://prod.demo-app.158.160.206.202.nip.io"
echo ""
echo "🔍 Check status:"
echo "  kubectl get applications -n argocd"
echo "  ./check-status.sh"
echo ""
echo "⚙️  Manual deployment commands:"
echo "  kubectl kustomize k8s-manifests/overlays/dev | kubectl apply -f -"
echo "  kubectl kustomize k8s-manifests/overlays/prod | kubectl apply -f -"
echo "========================================="
