#!/bin/bash

profile_new="$1"
profile_old="$2"
token="$3"
fail_on_diff="$4"
create_pr="$5"
pr_message="[Tracee](https://github.com/aquasecurity/tracee) has detected changes to the normal behavior of the workflow.
Review the changes in this PR and accept it in order to establish a new baseline."

diff $profile_new $profile_old
rc=$?
if [ $rc -ne 0 ]; then # diff found
  if [ "$create_pr" ]; then
    cp $profile_new $profile_old
    git config --global user.email "oss@aquasec.com"
    git config --global user.name "Tracee bot"
    gh auth login --with-token <<<"$token"
    git fetch --all
    git checkout -B 'tracee-profile-update' origin/$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
    git add $profile_old
    git commit -m 'update tracee profile'
    git push -f --set-upstream origin tracee-profile-update
    gh pr create --title "Updates to tracee profile" --body "$pr_message"
  fi
  [ "$fail_on_diff" ] && echo "***FAILING DUE TO PROFILE DEVIATION***" && exit 1
fi
