#!/bin/bash 

# INSTALL KUBECTL 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# INSTALL HELM

curl -LO  https://get.helm.sh/helm-v3.5.0-linux-amd64.tar.gz 

tar -xvzf helm-v3.5.0-linux-amd64.tar.gz

sudo install -o root -g root -m 0755 linux-amd64/helm /usr/local/bin/helm

# INSTALL RANCHER
curl -sfL https://get.rancher.io | sh -

systemctl enable rancherd-server
systemctl start rancherd-server

# Wait a few minutes 

#@TODO: Add wait conditions for Rancher to start up before issuing commands 

# Get UI keys
rancherd reset-admin

sudo chmod 0644 /etc/rancher/rke2/rke2.yaml

# Configure kuebctl 
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml PATH=$PATH:/var/lib/rancher/rke2/bin

