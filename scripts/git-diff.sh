#!/bin/bash
set -e

git add ./*

if [[ $(git --no-pager diff @\{upstream\}) != '' ]]; then
  git --no-pager diff @\{upstream\} --color
  echo -e '\033[0;31mGit outdated!\033[0m ❌'
  exit 1
else
  echo -e '\033[0;32mGit up to date\033[0m ✔'
fi
