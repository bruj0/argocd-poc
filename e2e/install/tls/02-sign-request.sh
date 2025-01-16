cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: gitea-https.gitea
spec:
  request: $(cat server.csr | base64 | tr -d '\n')
  signerName: nip.io/serving
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
sleep 2
kubectl describe csr gitea-https.gitea
sleep 1
kubectl certificate approve gitea-https.gitea
sleep 1
kubectl  get csr
