#!/bin/bash
set -xeuo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

npm install --save-dev --save-exact prettier || true
npx prettier --write .
