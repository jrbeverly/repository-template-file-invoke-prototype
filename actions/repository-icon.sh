#!/bin/bash
set -xeuo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p .repository/ || true
mkdir -p .repository/ack || true
mv docs/icon/logo.svg .repository/icon.svg || true
mv docs/icon/logo.json .repository/ack/icon.json || true
mv docs/icon/icon.svg .repository/icon.svg || true
mv docs/icon/icon.json .repository/ack/icon.json || true
mv docs/icon.svg .repository/icon.svg || true
mv docs/icon.json .repository/ack/icon.json || true

git add --force .repository/icon.svg || true
git add --force .repository/ack/icon.json || true