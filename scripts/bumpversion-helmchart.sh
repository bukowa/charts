#!/bin/bash
set -eux

BUMP=$(echo "$MESSAGE" | grep -Po '(?<=^chore\(deps\): )(patch|major|minor)')
./scripts/semver bump "${BUMP}" "$(grep -Po '(?<=^version: )[\x27\x220-9].*' "charts/${CHART}/Chart.yaml")"
