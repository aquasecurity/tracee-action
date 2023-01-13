def getarg(name): .args[] | select(.name == name) | .value;

[
  .[] | 
  { 
    user_id: .userId,
    process_name: .processName,
    binary_path: getarg("pathname"),
    binary_sha256: getarg("sha256"),
    binary_ctime: getarg("ctime")
  } 
] | sort_by(.binary_path)
