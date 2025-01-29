#!/usr/bin/env bash
set -x
# setup ArgoCD
. ./my-vars.sh

echo
ARGOCD_HOST="argocd.${INGRESS_DOMAIN}"
cat <<EOF | helm upgrade --install argocd argo/argo-cd --wait --create-namespace --namespace=argocd --values=-
configs:
  cm:
    admin.enabled: true
    timeout.reconciliation: 10s
  params:
    server.insecure: true
    server.disable.auth: true
  repositories:
    local:
      name: local
      url: http://gitea-http.gitea.svc.cluster.local:3000/gitea_admin/local-repo.git
    remote:
      name: argocd-examples
      url: https://github.com/argoproj/argocd-example-apps.git
server:
  ingress:
    enabled: true
    ingressClassName: nginx
    hostname: "${ARGOCD_HOST}"
EOF
