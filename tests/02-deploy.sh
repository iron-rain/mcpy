#!/bin/bash

helm install -f ./charts/minio/dev-values.yaml minio ./charts/minio -n minio
helm install -f ./charts/keycloak/dev-values.yaml keycloak ./charts/keycloak -n keycloak