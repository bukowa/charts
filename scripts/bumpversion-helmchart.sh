#!/bin/bash
set -eux

# CHART="http-headers"
# MESSAGE="chore(deps): patch update quay.io/k8start/http-headers docker tag to v0.1.3"
export BUMP=$(echo "$MESSAGE" | grep -Po '(?<=^chore\(deps\): )(patch|major|minor)')
export VERSION=$(./scripts/semver bump "${BUMP}" "$(yq -e ".version" < ./charts/http-headers/Chart.yaml)")
yq -e -i ".version = \"${VERSION}\"" ./charts/http-headers/Chart.yaml
