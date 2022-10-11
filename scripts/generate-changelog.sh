#!/bin/bash
set -eux

for chart in charts/*; do
  touch "$chart/CHANGELOG.md"
  echo "Generating CHANGELOG for $chart"
  git cliff \
    --include-path "${chart}/*" \
    --prepend "$chart/CHANGELOG.md" \
    --tag="$(grep -Po '(?<=^version: )[0-9.a-zA-Z]*' "${chart}/Chart.yaml")" \
    -l
done
