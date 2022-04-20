#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

git remote add github "https://${GH_USER}:${GH_PCA}@github.com/${GITHUB_REPOSITORY}.git" 

while [ true ]
do

  # If nothing exists within repository, exit the loop
  if [ ! -n "$(ls -A tasks/*.json 2>/dev/null)" ]
  then
    echo "No work available <1>"
    exit 0
  fi

  # Select a workitem
  export FILENAME=$(readlink -f `ls -U tasks/*.json | xargs shuf -n1 -e`)

  # Properties from action
  export ACTION_BRANCH=`jq -r '.branch' ${FILENAME}`
  export ACTION_SCRIPT=`jq -r '.script' ${FILENAME}`
  export ACTION_TITLE=`jq -r '.title' ${FILENAME}`
  export ACTION_BODY=`jq -r '.body' ${FILENAME}`
  export ACTION_GIT=`jq -r '.repository' ${FILENAME}`
  export ACTION_LABELS=`jq -r '.labels' ${FILENAME}`

  DIR_WORKING="/tmp/working_directory"
  rm -rf "${DIR_WORKING}"

  git clone "https://${GH_USER}:${GH_PCA}@github.com/${ACTION_GIT}.git" "${DIR_WORKING}"
  cd "${DIR_WORKING}"
  
  git checkout -b "${ACTION_BRANCH}"
  bash "${GITHUB_WORKSPACE}/${ACTION_SCRIPT}"

  git add -A
  if ! git diff-index --quiet HEAD ; then
      git commit -m "${ACTION_TITLE}"
      git remote add github "https://${GH_USER}:${GH_PCA}@github.com/${ACTION_GIT}.git"
      git push --force -u github HEAD

      gh pr create --title "${ACTION_TITLE}" --body "${ACTION_BODY}" --assignee "${GH_USER}" --label "${ACTION_LABELS}" || gh pr create --title "${ACTION_TITLE}" --body "${ACTION_BODY}" --assignee 'jrbeverly' || exit 1

      cd $GITHUB_WORKSPACE
      git checkout main
      git rm "${FILENAME}"
      git add -A
      git commit -m "Completed ${FILENAME}"
      git push -u github

      echo "done"
      exit 0
  else
      cd $GITHUB_WORKSPACE
      git checkout main
      git rm "${FILENAME}"
      git add -A
      git commit -m "Completed ${FILENAME}"
  fi

done

# Eventual push to ensure everything is up to date
git push -u github
echo "done"