#!/bin/bash

echo "🔑 Logging into ArgoCD..."

# Get ArgoCD admin password
PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d 2>/dev/null)

if [ -z "$PASSWORD" ]; then
    echo "❌ Could not get ArgoCD password"
    exit 1
fi

# Login to ArgoCD
argocd login argocd.158.160.206.202.nip.io \
  --username admin \
  --password "$PASSWORD" \
  --insecure

if [ $? -eq 0 ]; then
    echo "✅ Successfully logged into ArgoCD"
    echo ""
    echo "Available commands:"
    echo "  argocd app list"
    echo "  argocd app get demo-app-dev"
    echo "  argocd app sync demo-app-dev"
    echo "  argocd app history demo-app-dev"
else
    echo "❌ Failed to login to ArgoCD"
fi
