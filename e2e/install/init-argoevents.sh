#!/usr/bin/env bash
set -x

. ./my-vars.sh

helm install my-argo-events argo/argo-events --create-namespace --version 2.4.9 --values argo-events-values.yaml
sleep 5
