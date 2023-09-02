#!/bin/bash
set -o pipefail

profile_new="$1"
profile_old="$2"
token="$3"
create_pr="$4"
pr_message="[Tracee](https://github.com/aquasecurity/tracee) has detected deviation from normal behavior of the workflow.
Review the changes in this PR and accept it in order to establish a new baseline."

jq --null-input --exit-status --slurpfile "new" "$profile_new" --slurpfile "old" "$profile_old" '($new[0]-$old[0])!=[]'
rc=$?
if [ $rc -ne 0 ]; then # profile additions
  diff=$(diff <(jq --compact-output 'tostream' "$profile_old") <(jq --compact-output 'tostream' "$profile_new") | head -n 20)
  echo -e "changes:\n$diff"
  if [ "$create_pr" ]; then
    mkdir -p "$(dirname "$profile_old")"
    cp "$profile_new" "$profile_old"
    git config --global user.email "oss@aquasec.com"
    git config --global user.name "Tracee bot"
    gh auth login --with-token <<<"$token"
    git fetch --all
    git checkout -B 'tracee-profile-update' "origin/tracee-profile-update" || git checkout -B 'tracee-profile-update' "origin/$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)"
    git add "$profile_old"
    git commit -m 'update tracee profile'
    git push -f --set-upstream origin tracee-profile-update
    gh pr create --title "Updates to tracee profile" --body "$(echo -e "$pr_message\n\nchanges:\n\`\`\`\n$diff\n\`\`\`")"
  fi
fi
