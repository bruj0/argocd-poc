#!/usr/bin/env bash
set -x

. ./my-vars.sh

# Check if an argument is provided, otherwise use the value from my-vars.sh
NAMESPACE=${1:-$ARGO_EVENTS_NAMESPACE}

echo
cat <<EOF | kubectl -n ${NAMESPACE} apply -f -
---
apiVersion: argoproj.io/v1alpha1
kind: EventBus
metadata:
  name: default
spec:
  nats:
    native:
      # Optional, defaults to 3. If it is < 3, set it to 3, that is the minimal requirement.
      replicas: 3
      # Optional, authen strategy, "none" or "token", defaults to "none"
      auth: token
EOF