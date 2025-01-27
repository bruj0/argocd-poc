#!/usr/bin/env bash
set -x
. ./VARS.sh
# initialize directories for repos appA, appB, appC, helm-charts
repos=("appA" "appB" "appC" "helm-charts")
GITEA_API="http://${GITEA_HOST}/api/v1"
GITEA_USERNAME="gitea_admin"

for repo in "${repos[@]}"; do
  # Create repository in Gitea
  curl -X POST "${gitea_url}/admin/users/${GITEA_USERNAME}/repos" \
    -H "Authorization: token ${GITEA_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"${repo}\", \"private\": true}"
sleep 1
  if [[ ! -d "repos/${repo}" ]]; then
    mkdir -p "repos/${repo}"
    git clone "http://${GITEA_USERNAME}:${GITEA_TOKEN}@gitea.10.0.2.15.nip.io/${GITEA_USERNAME}/${repo}.git" "repos/${repo}"
  fi
done