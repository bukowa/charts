#!/bin/bash
set -eux

echo "Building docker image for git-cliff..."

GIT_CLIFF=$(docker build -q - <<EOF
  FROM ghcr.io/orhun/git-cliff/git-cliff:sha-0f38960
  WORKDIR /charts
  ENTRYPOINT ["git-cliff"]
EOF
)

CHANGELOG_PREPEND="${CHANGELOG_PREPEND:-1}"
CHANGELOG_OUTPUT="${CHANGELOG_OUTPUT:-1}"

for chart in charts/*; do
  echo "Generating CHANGELOG for $chart"

  if [[ "${CHANGELOG_PREPEND}" == 1 ]]; then
    touch "$chart/CHANGELOG.md"
    docker run --rm \
    --volume="${PWD}:/charts" \
    -u "$(id -u)" \
      \
      "${GIT_CLIFF}" \
      \
        --include-path "${chart}/*" \
        --prepend "$chart/CHANGELOG.md" \
        --tag="$(grep -Po '(?<=^version: )[\x27\x220-9].*' "${chart}/Chart.yaml" | tr -d \'\")" \
        -u \
        --verbose
  fi

  if [[ "${CHANGELOG_OUTPUT}" == 1 ]]; then
  # run it second time with output for chart releaser
  # https://github.com/orhun/git-cliff/issues/120
  docker run --rm \
  --volume="${PWD}:/charts" \
  -u "$(id -u)" \
    \
    "${GIT_CLIFF}" \
    \
      --include-path "${chart}/*" \
      --output "$chart/CHANGELOG.LATEST.md" \
      --tag="$(grep -Po '(?<=^version: )[0-9.a-zA-Z]*' "${chart}/Chart.yaml")" \
      -u \
      -s header \
      --verbose
  fi

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
