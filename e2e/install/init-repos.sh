#!/usr/bin/env bash
set -x
# initialize directories for repos appA, appB, appC, helm-charts
repos=("appA" "appB" "appC" "helm-charts")
gitea_url="http://gitea.10.0.2.15.nip.io/api/v1"
gitea_token="ee56cac6c4583150767e620dd5c7ccdd3bd1bda9"
gitea_user="gitea_admin"

for repo in "${repos[@]}"; do
  # Create repository in Gitea
  curl -X POST "${gitea_url}/admin/users/${gitea_user}/repos" \
    -H "Authorization: token ${gitea_token}" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"${repo}\", \"private\": true}"
sleep 1
  if [[ ! -d "repos/${repo}" ]]; then
    mkdir -p "repos/${repo}"
    git clone "http://${gitea_user}:${gitea_token}@gitea.10.0.2.15.nip.io/${gitea_user}/${repo}.git" "repos/${repo}"
  fi
done