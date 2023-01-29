# Configuring tracee-action

## Action configuration

### Start action
The following are the parameters that the **start** action accepts:

name | value | default | description
--- | --- | --- | ---
envs | true/false | false | If set to true, Tracee will collect environment variables for the execution profile

### Stop action
The following are the parameters that the **stop** action accepts:

name | value | default | description
--- | --- | --- | ---
fail-on-diff | true/false | false | If set to true, the action will fail if a diff is detected
create-pr | true/false | false | If set to true, the action will create a PR with profile changes

To configure the action, use the `with` keyword in the action definition:

```yaml
- name: Stop Tracee
  uses: aquasecurity/tracee-action@v0.3.0-stop
  with:
    fail-on-diff: true
    create-pr: true
```yaml

```

## Profile configuration

Profile is created under the `.tracee` directory in the root of the repository. You can control some aspects of profile creation with the `.tracee/profile-config.json` file.  

name | value | description
--- | --- | ---
args_discard | list of regular expressions | Every argument that matches a pattern will be discarded. For example, if you want to discard the `--token=something` argument from the `curl` command, you can add it to this list.
args_discard_pair | list of regular expressions | Every argument that matches a pattern will be discarded, as well as the argument that follows it. For example, if you want to discard the `--token something` argument from  the `curl` command (which will be parsed as two consecutive args), you can add it to this list.
env_discard | list of regular expressions | Every environment variable that matches a pattern will be discarded. For example, if you want to ignore the `GITHUB_TOKEN` environment variable, you can add it to this list.
dns_discard | list of regular expressions | Every domain name that matches a pattern will be discarded. For example, if you want to ignore the `github.com` DNS request, you can add it to this list.

You can see the [default profile configuration](../profile/profile-config.json) for example.
