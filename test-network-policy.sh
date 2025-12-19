#!/bin/bash
echo "Testing network policies..."

# Проверяем доступ к ingress извне
echo -e "\n1. Testing external ingress access:"
curl -s -H "Host: demo.158.160.206.202.nip.io" http://158.160.206.202 | grep -o "Welcome to nginx" || echo "Failed"

# Проверяем доступ из monitoring namespace
echo -e "\n2. Testing from monitoring namespace:"
kubectl run test-pod --image=busybox -n monitoring --rm -it --restart=Never -- sh -c 'echo "Testing connectivity..." && nslookup demo.demo-apps && wget -T3 -qO- http://demo.demo-apps 2>/dev/null && echo "✓ Access allowed from monitoring" || echo "✗ Access denied from monitoring"' 2>/dev/null

# Проверяем доступ из default namespace  
echo -e "\n3. Testing from default namespace:"
kubectl run test-pod --image=busybox --rm -it --restart=Never -- sh -c 'echo "Testing connectivity..." && nslookup demo.demo-apps && wget -T3 -qO- http://demo.demo-apps 2>/dev/null && echo "✓ Access allowed from default" || echo "✗ Access denied from default (expected)"' 2>/dev/null
