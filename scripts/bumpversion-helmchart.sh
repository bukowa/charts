#!/bin/bash
set -eux

# CHART="http-headers"
# MESSAGE="chore(deps): patch update quay.io/k8start/http-headers docker tag to v0.1.3"
if [[ -z "${CHART+x}" ]]; then >&2 echo "CHART must be set"; exit 1; fi
if [[ -z "${BUMP+x}" ]]; then
  if [[ -z "${MESSAGE+x}" ]]; then >&2 echo "MESSAGE or BUMP must be set!"; exit 1; fi
  BUMP=$(echo "$MESSAGE" | grep -Po '(?<=^chore\(deps\): )(patch|major|minor)')
  APP=$(cat "./charts/${CHART}/app")
fi

APP_MATCH="update ${APP} docker tag to v"

if [[ "${MESSAGE}" =~ ${APP_MATCH} ]]; then
  APP_VERSION=$(echo "$MESSAGE" | grep -Po '(?<=docker tag to v)(.*)')
  yq -e -i ".appVersion = \"${APP_VERSION}\"" ./charts/"${CHART}"/Chart.yaml
fi

VERSION=$(./scripts/semver bump "${BUMP}" "$(yq -e ".version" < ./charts/"${CHART}"/Chart.yaml)")
yq -e -i ".version = \"${VERSION}\"" ./charts/"${CHART}"/Chart.yaml
