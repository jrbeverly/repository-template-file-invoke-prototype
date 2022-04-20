#!/bin/bash
set -xeuo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p .github
mkdir -p .github/workflows
touch .github/workflows/github.labels.yml

cp "${DIR}/labels/github.labels.yml" .github/workflows/github.labels.yml
cp "${DIR}/labels/labels.json" .github/labels.json

git add --force .github/labels.json || true
git add --force .github/workflows/github.labels.yml || true