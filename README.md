# tracee-action

Simple example

```yaml
name: Tracee Pipeline Scan
on: [pull_request]

jobs:
  Tracee-Scan:
    runs-on: ubuntu-latest

    steps:
    - name: Start Tracee profiling in background
      uses: aquasecurity/tracee-action@v0.1.0-start

    - uses: actions/checkout@v2

    - name: Your CI Pipeline Step
      run: for i in {1..20}; do sleep 2; done

    - name: Stop and Check Tracee results and create a PR
      uses: aquasecurity/tracee-action@v0.1.0-stop
      with:
        fail-on-diff: "true"
        create-pr: "true"
```
