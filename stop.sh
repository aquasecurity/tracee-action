#!/bin/bash

workdir="$1"
token="$2"
fail_on_diff="$3"
create_pr="$4"
pr_message="VGhpcyBQUiBzaG93cyB0aGUgbGlzdCBvZiBwcm9jZXNzZXMgdGhhdCB3ZXJlIHJ1biBkdXJpbmcgdGhlIEdpdEh1YiBBY3Rpb25zIHBpcGVsaW5lLgoKVGhlIHByb2ZpbGUgaXMgYSBKU09OIG9iamVjdCB3aXRoIHRoZSBmb2xsb3dpbmcgc3ludGF4OgpgYGBqc29uCnsKICAibW91bnRfbnM6L3BhdGgvdG8vcHJvY2Vzczp0aW1lX3N0YW1wIjogewogICAgImZpbGVfaGFzaCI6IHN0cmluZwogIH0KfQpgYGAKCnwgRmllbGQgICAgICAgIHwgRGVzY3JpcHRpb24gICAgfAp8Oi0tLS0tLS0tLS0tLS06fCAtLS0tLS0tLS0tLS0tIHwKfCBtb3VudF9ucyAgICAgfCBNb3VudCBOYW1lU3BhY2Ugb2YgdGhlIHByb2Nlc3MgdGhhdCByYW4gfAp8IC9wYXRoL3RvL3Byb2Nlc3MgICAgICB8IEZpbGVwYXRoIGFuZCBuYW1lIG9mIHRoZSBwcm9jZXNzIHRoYXQgcmFuICAgICAgfAp8IHRpbWVfc3RhbXAgfCBDcmVhdGlvbiBVTklYIHRpbWVzdGFtcCBvZiB0aGUgcHJvY2VzcyB0aGF0IHJhbiAgICAgIHwKfCBmaWxlX2hhc2ggfCBBIFNIQTI1NiBjaGVja3N1bSBvZiB0aGUgcHJvY2VzcyBiaW5hcnkgfAoKCiFbVHJhY2VlIExvZ29dKGh0dHBzOi8vZ2l0aHViLmNvbS9hcXVhc2VjdXJpdHkvdHJhY2VlL3Jhdy9tYWluL2RvY3MvaW1hZ2VzL3RyYWNlZS5wbmcpCgpQb3dlcmVkIGJ5IFtBcXVhIFNlY3VyaXR5IFRyYWNlZV0oaHR0cHM6Ly9naXRodWIuY29tL2FxdWFzZWN1cml0eS90cmFjZWUp"

echo "Checking results..."
cmp --silent $workdir/out/tracee.profile ./tracee.profile
rc=$?
if [ $rc -ne 0 ]; then
  echo "Differences found..."
  diff "$workdir"/out/tracee.profile ./tracee.profile
  if [ $create_pr = "true" ]; then
    echo "Creating a commit with all changes..."
    cp $workdir/out/tracee.profile .
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