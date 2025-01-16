#!/bin/bash -x
cat <<EOF | cfssl genkey - | cfssljson -bare server
{
  "hosts": [
    "gitea-ingress.gitea.svc.cluster.local",
    "gitea-https.gitea.pod.cluster.local",
    "gitea-registry.10.0.2.15.nip.io",
    "gitea.10.0.2.15.nip.io",
    "argocd.10.0.2.15.nip.io",
    "workflows.10.0.2.15.nip.io"
  ],
  "key": {
    "algo": "ecdsa",
    "size": 256
  }
}
EOF