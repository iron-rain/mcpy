#!/bin/bash 

# ROOT CA
#openssl genrsa -out root/myCA.key 2048
#openssl req -x509 -new -nodes -key root/myCA.key -sha256 -days 1825 -out root/myCA.pem -subj "/CN=Dev CA"

# MINIO CERTS
openssl req -out minio/minio.csr -newkey rsa:2048 -nodes -keyout minio/minio.key -config minio/san.cnf

openssl x509 -req -days 365 -CA root/myCA.pem -CAkey root/myCA.key -CAcreateserial \
  -extensions SAN \
  -extfile <(cat /etc/ssl/openssl.cnf \
    <(printf "\n[SAN]\nsubjectAltName=DNS.1:minio.local")) \
  -in minio/minio.csr -out minio/minio.pem

# KEYCLOAK CERTS
openssl req -out keycloak/keycloak.csr -newkey rsa:2048 -nodes -keyout keycloak/keycloak.key -config keycloak/san.cnf

openssl x509 -req -days 365 -CA root/myCA.pem -CAkey root/myCA.key -CAcreateserial \
  -extensions SAN \
  -extfile <(cat /etc/ssl/openssl.cnf \
    <(printf "\n[SAN]\nsubjectAltName=DNS.1:keycloak.local")) \
  -in keycloak/keycloak.csr -out keycloak/keycloak.pem