#!/bin/bash

echo "🧪 Testing GitOps Deployment"
echo "============================"

# Test 1: Build kustomize configurations
echo ""
echo "1. Testing Kustomize builds..."
echo "Dev configuration:"
kubectl kustomize k8s-manifests/overlays/dev --enable-alpha-plugins > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Dev kustomize build successful"
else
    echo "❌ Dev kustomize build failed"
fi

echo "Prod configuration:"
kubectl kustomize k8s-manifests/overlays/prod --enable-alpha-plugins > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Prod kustomize build successful"
else
    echo "❌ Prod kustomize build failed"
fi

# Test 2: Validate YAML
echo ""
echo "2. Validating YAML files..."
if which yamllint >/dev/null 2>&1; then
    yamllint k8s-manifests/ -q
    echo "✅ YAML validation complete"
else
    echo "⚠️  yamllint not installed, skipping YAML validation"
fi

# Test 3: Check namespaces exist
echo ""
echo "3. Checking namespaces..."
kubectl get namespace dev > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ dev namespace exists"
else
    echo "❌ dev namespace not found"
fi

kubectl get namespace prod > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ prod namespace exists"
else
    echo "❌ prod namespace not found"
fi

# Test 4: Check ArgoCD applications
echo ""
echo "4. Checking ArgoCD applications..."
kubectl get applications -n argocd demo-app-dev > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ demo-app-dev application exists"
else
    echo "❌ demo-app-dev application not found"
fi

kubectl get applications -n argocd demo-app-prod > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ demo-app-prod application exists"
else
    echo "❌ demo-app-prod application not found"
fi

echo ""
echo "🎯 Testing complete!"
echo ""
echo "Next steps:"
echo "1. Run: ./setup-argocd.sh"
echo "2. Check status: ./check-sync.sh"
echo "3. Access ArgoCD UI to monitor deployment"
