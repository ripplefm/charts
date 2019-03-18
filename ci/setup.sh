#! /bin/bash

# install sops
curl -L -s https://github.com/mozilla/sops/releases/download/3.2.0/sops-3.2.0.linux --output sops && \
  chmod +x sops && \
  sudo mv sops /usr/local/bin/sops


# install kubectl
curl -L -s https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl --output kubectl && \
  chmod +x kubectl && \
  sudo mv kubectl /usr/local/bin/kubectl

# get kubeconfig from digitalocean api
mkdir "${HOME}/.kube" && \
  curl -X GET -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${DO_TOKEN}" \
  "https://api.digitalocean.com/v2/kubernetes/clusters/${CLUSTER_ID}/kubeconfig" \
  --output "${HOME}/.kube/config"

# install helm, helm-diff and helm-secrets
curl -L -s https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz --output helm.tar.gz && \
  tar -zxvf helm.tar.gz && \
  sudo mv linux-amd64/helm /usr/local/bin/helm && \
  helm init --client-only && \
  helm plugin install https://github.com/databus23/helm-diff && \
  helm plugin install https://github.com/futuresimple/helm-secrets

# install helmfile
curl -L -s https://github.com/roboll/helmfile/releases/download/v0.45.3/helmfile_linux_amd64 --output helmfile && \
  chmod +x helmfile && \
  sudo mv helmfile /usr/local/bin/helmfile

# import pgp key
gpg --import ./ci/pgp/key.asc
