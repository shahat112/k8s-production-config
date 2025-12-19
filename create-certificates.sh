#!/bin/bash

# Certificate для demo (namespace: default)
kubectl apply -n default -f - << YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: demo-certificate
spec:
  secretName: demo-tls-secret
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  commonName: demo.158.160.206.202.nip.io
  dnsNames:
  - demo.158.160.206.202.nip.io
YAML

# Certificate для apache.demo (namespace: demo-apps)
kubectl apply -n demo-apps -f - << YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: apache-demo-certificate
spec:
  secretName: apache-demo-tls-secret
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  commonName: apache.demo.158.160.206.202.nip.io
  dnsNames:
  - apache.demo.158.160.206.202.nip.io
YAML

# Certificate для nginx.demo (namespace: demo-apps)
kubectl apply -n demo-apps -f - << YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx-demo-certificate
spec:
  secretName: nginx-demo-tls-secret
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  commonName: nginx.demo.158.160.206.202.nip.io
  dnsNames:
  - nginx.demo.158.160.206.202.nip.io
YAML

# Certificate для dev.demo-app (namespace: dev)
kubectl apply -n dev -f - << YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: dev-demo-app-certificate
spec:
  secretName: dev-demo-app-tls-secret
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  commonName: dev.demo-app.158.160.206.202.nip.io
  dnsNames:
  - dev.demo-app.158.160.206.202.nip.io
YAML
