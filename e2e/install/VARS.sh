#INGRESS_IP=$(ip addr show $(ip route get 1.2.3.4 | grep -oP 'dev \K\S+') | grep -w 'inet' | awk '{print $2}' | cut -d/ -f1)    │
INGRESS_IP=""
INGRESS_DOMAIN="${INGRESS_IP}.nip.io"

## Gitea
GITEA_HOST="gitea.${INGRESS_DOMAIN}"
GITEA_USERNAME=gitea_admin
GITEA_PASSWORD=xxxxxx
GITEA_TOKEN="xxxx"