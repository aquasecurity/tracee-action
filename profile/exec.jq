def getarg(name): .args[] | select(.name == name) | .value;

[
  .[] | 
  { 
    userId: .userId,
    processName: .processName,
    binary_path: getarg("pathname"),
    binary_sha256: getarg("sha256"),
    binary_ctime: getarg("ctime"),
    command_argv: getarg("argv"),
    command_env: getarg("env")
  }
]
