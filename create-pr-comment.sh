#!/bin/bash
set -o pipefail

token="$1"

gh auth login --with-token <<<"$token"

pull_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
comment=$(cat <<EOF
This PR has triggered the signatures:

$(jq .eventName /tmp/tracee-action/signatures.jsonl | sort | uniq )

Please review the Tracee [documentation](https://aquasecurity.github.io/tracee/v0.10/docs/detecting/rules/) to understand the signatures, and review the details of each trigger on the json below:

\`\`\`
$(cat /tmp/tracee-action/signatures.jsonl)
\`\`\`
EOF
)

comment=${comment:0:65536}
gh pr comment $pull_number -b "$comment"
