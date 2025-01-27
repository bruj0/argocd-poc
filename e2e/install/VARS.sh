#INGRESS_IP=$(ip addr show $(ip route get 1.2.3.4 | grep -oP 'dev \K\S+') | grep -w 'inet' | awk '{print $2}' | cut -d/ -f1)    │
INGRESS_IP="10.0.1.61"
INGRESS_DOMAIN="${INGRESS_IP}.nip.io"

## Gitea
GITEA_HOST="gitea.${INGRESS_DOMAIN}"
GITEA_USERNAME=gitea_admin
GITEA_PASSWORD=admin82198
GITEA_TOKEN="ee56cac6c4583150767e620dd5c7ccdd3bd1bda9"