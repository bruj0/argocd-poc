#!/bin/bash -x
kubectl get csr gitea-https.gitea -o jsonpath='{.status.certificate}' \
    | base64 --decode > server.crt
kubectl -n gitea create secret tls gitea-https-tls --cert server.crt --key server-key.pem
kubectl -n gitea create configmap nip-io-ca --from-file ca.crt=ca.pem