#!/bin/bash
set -xeuo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update
sudo apt install yq -y

mkdir -p .repository/
rm -f .repository/index.yaml
touch .repository/index.yaml

write_yq() {
    yq w -i .repository/index.yaml "$1" "$2"
}

curl -u "jrbeverly:${GH_PCA}" -H "Accept: application/vnd.github.mercy-preview+json" https://api.github.com/repos/${ACTION_GIT} > repo.json
curl -u "jrbeverly:${GH_PCA}" -H "Accept: application/vnd.github.mercy-preview+json" https://api.github.com/repos/${ACTION_GIT}/topics > topics.json

slug=`echo ${ACTION_GIT} | cut -d'/' -f2`
namespace=`jq -r '.namespace' ${FILENAME}`
project=`jq -r '.project' ${FILENAME}`
if [ -f "LICENSE" ]; then
   license_year=$(cat LICENSE | grep 'Copyright' | tr -dc '0-9')
else
   license_year="2021"
fi

write_yq "slug" "${slug}"
write_yq "description" "$(jq -r '.description' repo.json)"
write_yq "project" "${project}"
write_yq "namespace" "${namespace}"
write_yq "status" "archived"
write_yq "icon" "icon.svg"
write_yq "license.type" "MIT"
write_yq "license.content" "Jonathan Beverly <jrbeverly>"
write_yq "license.year" "${license_year}"
write_yq "topics" "$(jq -r '.names' topics.json)"
rm -f topics.json
rm -f repo.json

git add -f .repository/index.yaml
git rm -f .repository/index.json || true