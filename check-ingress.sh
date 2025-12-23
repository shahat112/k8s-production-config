#!/bin/bash
echo "Проверяем конфигурацию Ingress:"
kubectl get ingress demo-app -n prod -o jsonpath='Host: {.spec.rules[0].host}{"\n"}Service: {.spec.rules[0].http.paths[0].backend.service.name}{"\n"}Port: {.spec.rules[0].http.paths[0].backend.service.port.number}{"\n"}'

echo ""
echo "Для исправления Ingress выполните:"
cat << 'INGRESS_FIX'
kubectl apply -f - << 'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-app
  namespace: prod
spec:
  rules:
  - host: prod.demo-app.158.160.206.202.nip.io
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: demo-app
            port:
              number: 80
YAML
INGRESS_FIX
