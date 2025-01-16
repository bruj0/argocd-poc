#!/usr/bin/env bash
set -x
INGRESS_IP=$(ip addr show $(ip route get 1.2.3.4 | grep -oP 'dev \K\S+') | grep -w 'inet' | awk '{print $2}' | cut -d/ -f1)
INGRESS_DOMAIN="${INGRESS_IP}.nip.io"
GITEA_HOST="gitea-registry.${INGRESS_DOMAIN}"

kubectl -n gitea apply -f gitea-registry-ingress.yaml

REGISTRY_DIR="/etc/containerd/certs.d/${GITEA_HOST}"
for node in $(kind get nodes); do
  docker exec "${node}" mkdir -p "${REGISTRY_DIR}"
  cat <<EOF | docker exec -i "${node}" cp /dev/stdin "${REGISTRY_DIR}/hosts.toml"
[host."http://${GITEA_HOST}"]
EOF
#kill -HUP $(pidof containerd)
done