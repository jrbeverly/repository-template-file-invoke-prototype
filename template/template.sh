#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR_ROOT="$( dirname "${DIR}" )"

REPOSITORIES="$1"
TEMPLATE="$2"
TEMPLATE_FILE="${DIR}/action/${TEMPLATE}.json"
while IFS= read -r repo; do
    echo "The repository: $repo"
    filename=`echo $repo | tr / _`
    
    export project_set="${REPOSITORIES}"
    export line="${repo}"
    envsubst < "${TEMPLATE_FILE}" > "${DIR_ROOT}/tasks/${TEMPLATE}_${filename}.json"
done < "${DIR}/data/${REPOSITORIES}.txt"