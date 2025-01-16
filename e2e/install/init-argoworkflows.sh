#!/usr/bin/env bash
set -x
helm repo add argo https://argoproj.github.io/argo-helm
#TODO: Add minio for artifact storage
#https://argo-workflows.readthedocs.io/en/latest/configure-artifact-repository/

helm install my-argo-workflows argo/argo-workflows -n kube-system --version  0.45.2 --values argo-workflows-values.yaml
sleep 1

kubectl -n guestbook create role workflow-client-role --verb=list,update --resource=workflows.argoproj.io
kubectl -n guestbook create sa workflow-client-sa
kubectl -n guestbook create rolebinding workflow-client-rb --role=workflow-client-role --serviceaccount=guestbook:workflow-client-sa
sleep 5
TEMP_TOKEN="Bearer $(kubectl -n guestbook create token workflow-client-sa)"
echo $TEMP_TOKEN


#Static cluster admin token
kubectl -n guestbook create sa workflow-admin-sa
kubectl -n guestbook create rolebinding workflow-admin-rb --clusterrole=admin --serviceaccount=guestbook:workflow-admin-sa
kubectl create clusterrolebinding workflow-admin-crb --clusterrole=admin --serviceaccount=guestbook:workflow-admin-sa
sleep 2
kubectl -n guestbook apply -f argo-workflows-admin-token.yaml
sleep 2
ARGO_TOKEN="Bearer $(kubectl -n guestbook get secret workflow-client-token -o=jsonpath='{.data.token}' | base64 --decode)"
echo $ARGO_TOKEN
