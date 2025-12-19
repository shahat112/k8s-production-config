#!/bin/bash

echo "🔍 Checking ArgoCD Sync Status"
echo "=============================="

# Check ArgoCD applications
echo ""
echo "1. ArgoCD Applications:"
kubectl get applications -n argocd -o wide

echo ""
echo "2. Application Details:"
echo "----------------------"

for app in $(kubectl get applications -n argocd -o name | cut -d/ -f2); do
    echo ""
    echo "Application: $app"
    echo "Sync Status: $(kubectl get application $app -n argocd -o jsonpath='{.status.sync.status}')"
    echo "Health Status: $(kubectl get application $app -n argocd -o jsonpath='{.status.health.status}')"
    echo "Repo: $(kubectl get application $app -n argocd -o jsonpath='{.spec.source.repoURL}')"
    echo "Path: $(kubectl get application $app -n argocd -o jsonpath='{.spec.source.path}')"
done

echo ""
echo "3. Pod Status in Namespaces:"
echo "---------------------------"
echo "Dev namespace:"
kubectl get pods -n dev 2>/dev/null || echo "No pods in dev namespace"

echo ""
echo "Prod namespace:"
kubectl get pods -n prod 2>/dev/null || echo "No pods in prod namespace"

echo ""
echo "4. Ingress Routes:"
echo "-----------------"
kubectl get ingress -A | grep -E "(NAME|dev|prod)" | head -10

echo ""
echo "✅ Check complete!"
echo ""
echo "To manually sync applications:"
echo "  argocd app sync demo-app-dev"
echo "  argocd app sync demo-app-prod"
