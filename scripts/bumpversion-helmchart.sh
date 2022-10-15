#!/bin/bash
set -eux

# CHART="http-headers"
# MESSAGE="chore(deps): patch update quay.io/k8start/http-headers docker tag to v0.1.3"
if [[ -z "$CHART" ]]; then >&2 echo "CHART must be set"; exit 1; fi
if [[ -z "$BUMP" ]]; then
  if [[ -z "$MESSAGE" ]]; then >&2 echo "MESSAGE or BUMP must be set!"; exit 1; fi
  BUMP=$(echo "$MESSAGE" | grep -Po '(?<=^chore\(deps\): )(patch|major|minor)')
fi

VERSION=$(./scripts/semver bump "${BUMP}" "$(yq -e ".version" < ./charts/"${CHART}"/Chart.yaml)")
yq -e -i ".version = \"${VERSION}\"" ./charts/"${CHART}"/Chart.yaml
