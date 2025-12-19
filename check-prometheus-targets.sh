#!/bin/bash
echo "Checking Prometheus targets..."

# Получаем доступ к Prometheus UI
echo -e "\n1. Starting port-forward to Prometheus (Ctrl+C to stop)..."
echo "Open in browser: http://localhost:9090/targets"
kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090 -n monitoring
