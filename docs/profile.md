# Profile

The following profile files are created under the `.tracee` directory in the root of the repository:
- `profile-exec.json` - contains the execution profile of the workflow
- `profile-files.json` - contains the files that were modified during the workflow, under the "workspace" directory
- `profile-network.json` - contains the network connections that were made during the workflow

## Execution profile

name | description
--- | ---
`binary_path` | The path of the binary that was executed
`binary_hash` | The hash of the binary that was executed
`process_uid` | The user ID of the process that executed the binary
`process_args` | The arguments that were passed in the command invocation
`process_env` | The environment variables that were set in the process

`process_args` and `process_env` are filtered according to the configuration in the [profile configuration file](./config.md#profile-configuration).

`process_env` is disabled by default and can be enabled by setting the `envs` parameter to `true` in the [start action configuration](./config.md#start-action).

## Files profile

An array of file paths.

## Network profile

An array of domain names that were accessed during the workflow.

The list can be filtered by setting the `dns_discard` parameter in the [profile configuration file](./config.md#profile-configuration).
