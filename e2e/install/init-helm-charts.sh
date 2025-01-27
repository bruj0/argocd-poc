helm plugin install https://github.com/chartmuseum/helm-push
helm package guestbook/
helm repo add --username gitea_admin --password admin82198 gitea-helm-registry http://gitea.10.0.2.15.nip.io/api/packages/gitea_admin/helm
helm cm-push ./guestbook-0.1.1.tgz gitea-helm-registry