#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR_ROOT="$( dirname "${DIR}" )"

ORGANIZATION="jrbeverly"

RESULT_FILE="${DIR_ROOT}/template/data/${ORGANIZATION}.txt"
BASE_URL="https://api.github.com/users/${ORGANIZATION}/repos"
URL="${BASE_URL}"

rm -f "${RESULT_FILE}"
touch "${RESULT_FILE}"
for ((i=2; ; i+=1)); do
    echo "${URL}"
    contents="$(curl -u "${GITHUB_USER}:${GITHUB_TOKEN}" -s "${URL}")"
    if jq -e '..|select(type == "array" and length == 0)' <<< "${contents}" >/dev/null; then 
       break
    fi

    URL="${BASE_URL}?page=${i}"
    echo "${contents}" | jq -r '.[] | .full_name' | tr '[:upper:]' '[:lower:]' >>"${RESULT_FILE}"
done