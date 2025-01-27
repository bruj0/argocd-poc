#!/usr/bin/env bash
set -x
# setup ArgoCD
. ./VARS.sh

echo
cat <<EOF | helm upgrade --install gitea gitea-charts/gitea --wait --create-namespace --namespace=gitea --values=-
ingress:
  enabled: true
  hosts:
  - host: "${GITEA_HOST}"
    paths:
      - path: /
        pathType: Prefix

postgresql:
  enabled: true
postgresql-ha:
  enabled: false

gitea:
  admin:
    username: ${GITEA_USERNAME}
    password: ${GITEA_PASSWORD}
extraVolumes:
- name: host-mount
  hostPath:
    path: /home/gitea
extraContainerVolumeMounts:
- name: host-mount
  mountPath: /data/git/gitea-repositories
initPreScript: mkdir -p /data/git/gitea-repositories/gitea_admin
EOF
