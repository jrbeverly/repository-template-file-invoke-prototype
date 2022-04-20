#!/bin/bash
set -xeuo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p .repository/
touch .repository/index.json
echo "{}" > .repository/index.json

write_jq() {
    jq "$@" .repository/index.json > .repository/index.json.tmp
    mv .repository/index.json.tmp .repository/index.json
    cat .repository/index.json
}

curl -u "jrbeverly:${GH_PCA}" -H "Accept: application/vnd.github.mercy-preview+json" https://api.github.com/repos/${ACTION_GIT}/topics > topics.json
curl -u "jrbeverly:${GH_PCA}" -H "Accept: application/vnd.github.mercy-preview+json" https://api.github.com/repos/${ACTION_GIT}/languages > langs.json

slug=`echo ${ACTION_GIT} | cut -d'/' -f2`
namespace=`echo ${ACTION_GIT} | cut -d'/' -f1`

write_jq ".slug = \"${slug}\""
write_jq ".namespace = \"${namespace}\""
write_jq '.status = "archived"'
write_jq '.icon = "icon.svg"'
write_jq '.license.type = "MIT"'
write_jq '.license.content = "Jonathan Beverly <jrbeverly>"'
write_jq ".topics = $(jq -r '.names' topics.json)"
write_jq ".languages = $(jq -r 'keys' langs.json)"
rm topics.json
rm langs.json