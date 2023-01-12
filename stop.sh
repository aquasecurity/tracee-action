#!/bin/bash

workdir="$1"
token="$2"
fail_on_diff="$3"
create_pr="$4"
pr_message="VGhpcyBQUiBzaG93cyB0aGUgbGlzdCBvZiBwcm9jZXNzZXMgdGhhdCB3ZXJlIHJ1biBkdXJpbmcgdGhlIEdpdEh1YiBBY3Rpb25zIHBpcGVsaW5lLgoKVGhlIHByb2ZpbGUgaXMgYSBKU09OIG9iamVjdCB3aXRoIHRoZSBmb2xsb3dpbmcgc3ludGF4OgpgYGBqc29uCnsKICAibW91bnRfbnM6L3BhdGgvdG8vcHJvY2Vzczp0aW1lX3N0YW1wIjogewogICAgInRpbWVzIjogaW50CiAgICAiZmlsZV9oYXNoIjogc3RyaW5nCiAgfQp9CmBgYAoKfCBGaWVsZCAgICAgICAgfCBEZXNjcmlwdGlvbiAgICB8Cnw6LS0tLS0tLS0tLS0tLTp8IC0tLS0tLS0tLS0tLS0gfAp8IG1vdW50X25zICAgICB8IE1vdW50IE5hbWVTcGFjZSBvZiB0aGUgcHJvY2VzcyB0aGF0IHJhbiB8CnwgL3BhdGgvdG8vcHJvY2VzcyAgICAgIHwgRmlsZXBhdGggYW5kIG5hbWUgb2YgdGhlIHByb2Nlc3MgdGhhdCByYW4gICAgICB8CnwgdGltZV9zdGFtcCB8IENyZWF0aW9uIFVOSVggdGltZXN0YW1wIG9mIHRoZSBwcm9jZXNzIHRoYXQgcmFuICAgICAgfAp8IHRpbWVzIHwgTnVtYmVyIG9mIHRpbWVzIHRoZSBwcm9jZXNzIHdhcyBleGVjdXRlZCB8CnwgZmlsZV9oYXNoIHwgQSBTSEEyNTYgY2hlY2tzdW0gb2YgdGhlIHByb2Nlc3MgYmluYXJ5IHwKCgohW1RyYWNlZSBMb2dvXShodHRwczovL2dpdGh1Yi5jb20vYXF1YXNlY3VyaXR5L3RyYWNlZS9yYXcvbWFpbi9kb2NzL2ltYWdlcy90cmFjZWUucG5nKQoKUG93ZXJlZCBieSBbQXF1YSBTZWN1cml0eSBUcmFjZWVdKGh0dHBzOi8vZ2l0aHViLmNvbS9hcXVhc2VjdXJpdHkvdHJhY2VlKQo="

echo "Checking changed files..."

cp $workdir/out/tracee.profile /tmp/new-tracee.profile

IFS=$'\n'
for i in $(git status -s); do
	jq --arg val $i '.files_changed += [$val]' /tmp/new-tracee.profile > /tmp/tracee.profile.tmp
	mv /tmp/tracee.profile.tmp /tmp/new-tracee.profile
done

echo "Checking results..."
cmp --silent /tmp/new-tracee.profile ./tracee.profile
rc=$?
if [ $rc -ne 0 ]; then
  echo "Differences found..."
  diff /tmp/new-tracee.profile ./tracee.profile
  diff --color=auto <(jq -S . ./tracee.profile) <(jq -S . /tmp/new-tracee.profile)
  if [ $create_pr = "true" ]; then
    echo "Creating a commit with all changes..."
    cp /tmp/new-tracee.profile ./tracee.profile
    git config --global user.email "opensource@aquasec.com"
    git config --global user.name "Tracee Bot"
    gh auth login --with-token <<<"$token"
    git fetch --all
    git checkout -B 'tracee-profile-update' origin/$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
    git add tracee.profile
    git commit -m 'update tracee.profile'
    git push -f --set-upstream origin tracee-profile-update
    gh pr create --title "Updates to tracee.profile" --body "$(echo $pr_message | base64 -d)"
    echo "PR Created"
  fi

  if [ $fail_on_diff = "true" ]; then
    exit 1
  else
    exit 0
  fi
else
  echo "No profile differences found"
  exit 0
fi
