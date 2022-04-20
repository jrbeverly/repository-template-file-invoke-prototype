#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

organizations=( "blockycraft" "devkitspaces" "xplatformer" "thefriending" "cardboardci" "infraprints" )
for org in "${organizations[@]}"
do
    bash "${DIR}/repos.sh" "${org}"
done