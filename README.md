**This project is for demonstration purpose only. It is not under active development. Use at your own risk**
Watch a detailed introduction to the project: https://youtu.be/nNqrPNEqtw0

# Protect your GitHub Actions with Tracee

[Tracee](https://github.com/aquasecurity/tracee) is a powerful open source runtime security and forensics solution. It is using eBPF to trace your system, produce rich events that gives you visibility into what is happening under the hood, and also detects suspicious behavior in those event.

This project is using Tracee to protect GitHub Actions workflow against supply chain attacks.

## Protection

tracee-action offers two kinds of protection that complements each other: Events, and Profile.

### Signatures

Tracee runs in the background and hunts for suspicious behavior in the runner and in the workflow. It uses the powerful set of behavioral signatures that is available for Tracee, and you can add your own specific signatures to detect unwanted behavior.
Signatures detections are reported to you as a comment on the PR that triggered the action for your review.
You can review the list of events in the default policy [here](policies/signatures.yaml.tmpl)

### Profile

While the profile is running Tracee builds a profile that describes how your workflow normally behaves. Once you approve this initial profile as the baseline, tracee-action will detect and report any deviation from it.
Profile deviations are reported to you as a new PR that add commits the changes to a `.tracee` directory in the project.
You can review the contents of the default profile [here](docs/profile.md)

## Getting Started

Add tracee-action to the beginning of your workflow with the tag ending with `-start`, and to the end of your workflow with the tag ending with `-stop`.
Example:

```yaml
name: My pipeline
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
    - name: Start Tracee
      uses: aquasecurity/tracee-action@v0.3.0-start

    ...

    - name: Stop Tracee
      uses: aquasecurity/tracee-action@v0.3.0-stop
```

There are some configuration options the are detailed [here](docs/config.md)
