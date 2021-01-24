#!/bin/bash

echo '--------'
echo 'Creating Namespaces'
kubectl create ns minio
kubectl create ns keycloak
echo ''
echo '--------'
echo 'Creating Secrets'
kubectl create secret -n minio generic minio-tls --from-file=public.crt=./certs/minio/minio.pem --from-file=private.key=./certs/minio/minio.key
kubectl create secret -n minio tls minio-tls-ext --cert=./certs/minio/minio.pem --key=./certs/minio/minio.key
kubectl create secret -n minio generic minio-tls-ca --from-file=ca.crt=./certs/root/myCA.pem

kubectl create secret -n keycloak tls keycloak-tls-ext --cert=./certs/keycloak/keycloak.pem --key=./certs/keycloak/keycloak.key