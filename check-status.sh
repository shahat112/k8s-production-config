#!/bin/bash

echo "🔍 Checking GitOps Status..."
echo "=============================="

echo ""
echo "1. ArgoCD Applications:"
kubectl get applications -n argocd

echo ""
echo "2. Pod Status:"
kubectl get pods -n dev
kubectl get pods -n prod

echo ""
echo "3. Sync Status:"
for app in $(kubectl get applications -n argocd -o name); do
    echo "--- $app ---"
    kubectl get $app -n argocd -o jsonpath='{.status.sync.status} {"\n"}'
done

echo ""
echo "4. Ingress Routes:"
kubectl get ingress -A | grep -E "(dev|prod)"

echo ""
echo "5. Monitoring Targets:"
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090 > /dev/null &
sleep 2
curl -s "http://localhost:9090/api/v1/targets" | jq -r '.data.activeTargets[] | select(.labels.namespace == "dev" or .labels.namespace == "prod") | "\(.labels.namespace)/\(.labels.pod) - \(.health)"'
pkill -f "kubectl port-forward"

echo ""
echo "✅ Status check complete!"
