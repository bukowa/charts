#!/bin/bash
set -eux

git add -A

if [[ $(git --no-pager diff --stat --cached) != '' ]]; then
  git --no-pager diff --color --cached
  echo -e '\033[0;31mGit outdated!\033[0m ❌'
  exit 1
else
  echo -e '\033[0;32mGit up to date\033[0m ✔'
  exit 0
fi

exit 1
