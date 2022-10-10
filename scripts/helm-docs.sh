#!/bin/bash
## this file is copied from
## https://github.com/argoproj/argo-helm/blob/20924aced32bf53228876753ac879bef5c5f0c3e/scripts/helm-docs.sh
## Reference: https://github.com/norwoodj/helm-docs
set -eux
CHART_DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "$CHART_DIR"

echo "Running Helm-Docs"
docker run \
    -v "$CHART_DIR:/helm-docs" \
    -u $(id -u) \
    jnorwood/helm-docs
