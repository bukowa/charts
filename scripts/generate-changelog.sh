#!/bin/bash
set -eux

echo "Building docker image for git-cliff..."

GIT_CLIFF=$(docker build -q - <<EOF
  FROM ghcr.io/orhun/git-cliff/git-cliff:sha-0f38960
  WORKDIR /charts
  ENTRYPOINT ["git-cliff"]
EOF
)

for chart in charts/*; do
  echo "Generating CHANGELOG for $chart"
  touch "$chart/CHANGELOG.md"
  docker run --rm \
  --volume="${PWD}:/charts" \
  -u "$(id -u)" \
    \
    "${GIT_CLIFF}" \
    \
      --include-path "${chart}/*" \
      --prepend "$chart/CHANGELOG.md" \
      --tag="$(grep -Po '(?<=^version: )[0-9.a-zA-Z]*' "${chart}/Chart.yaml")" \
      -l \
      --verbose
done


## GENERATE WITHOUT DOCKER

#CHART_DIR="${PWD}/charts"
#echo "${CHART_DIR}"
#
#for chart in charts/*; do
#  touch "$chart/CHANGELOG.md"
#  echo "Generating CHANGELOG for $chart"
#  git cliff \
#    --include-path "${chart}/*" \
#    --prepend "$chart/CHANGELOG.md" \
#    --tag="$(grep -Po '(?<=^version: )[0-9.a-zA-Z]*' "${chart}/Chart.yaml")" \
#    -l --verbose
#done
