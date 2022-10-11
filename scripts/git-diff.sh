#!/bin/bash

git add ./*

if [[ $(git diff --stat) != '' ]]; then
  echo -e '\033[0;31mGit outdated!\033[0m ❌'
  git diff --color
  exit 1
else
  echo -e '\033[0;32mGit up to date\033[0m ✔'
fi
