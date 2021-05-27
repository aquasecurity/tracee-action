# Tracee Action

## Usage

```yaml
name: Tracee Pipeline Scan
on: [pull_request]

jobs:
  Tracee-Scan:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Start Tracee profiling in background
      uses: aquasecurity/tracee-action@v0.1.0-start

    - name: Your CI Pipeline Step
      run: for i in {1..20}; do sleep 2; done

    - name: Stop and Check Tracee results and create a PR
      uses: aquasecurity/tracee-action@v0.1.0-stop
      with:
        fail-on-diff: "true"
        create-pr: "true"
```

## Options

| Option        | Default | Description    |
|:-------------:|:-------------:|------------- |
| fail-on-diff   | false | If differences are observed, pipeline will be failed out |
| create-pr      | false | Tracee Action will create a PR with observed differences    |

