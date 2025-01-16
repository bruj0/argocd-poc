#!/bin/bash -x
URL="http://gitea-http.gitea.svc.cluster.local:3000"
#username:password in base64
user=gitea_admin
password=562e755c0e22086d8a3df457be63aeeecbbc5d8c
auth=$(printf "${user}:${password}" | base64) 
#"Z2l0ZWFfYWRtaW46NTYyZTc1NWMwZTIyMDg2ZDhhM2RmNDU3YmU2M2FlZWVjYmJjNWQ4Yw=="
NS="guestbook"
# kubectl -n ${NS} create secret generic docker-config --from-literal=config.json="$(cat <<EOF
# {
#     "auths": {
#         "${URL}": {
#             "auth": "${auth}"
#         }
#     }
# }
# EOF
# )"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
    name: docker-config
    namespace: ${NS}
data:
    config.json: $(echo -n "{\"auths\":{\"${URL}\":{\"auth\":\"${auth}\"}}}" | base64)
type: Opaque
EOF

