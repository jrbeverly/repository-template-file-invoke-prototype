#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR_ROOT="$( dirname "${DIR}" )"

(
    cd "${DIR}/data"
    for x in *
    do
        bash "${DIR}/template.sh" ${x%.txt} $@
    done
)