# getarg returns the value of the argument with the given name from a Tracee execution event
def getarg(name): .args[] | select(.name == name) | .value;

# discard_items discards all items in the input array of strings that starts with a prefix from the prefixes array of strings
def discard_items(prefixes): if prefixes | length > 0 then map(select([startswith(prefixes[])] | any | not)) else . end;


[ .[] ] | sort_by(.timestamp) | .[] |
  { 
    user_id: .userId,
    process_name: .processName,
    binary_path: getarg("pathname"),
    binary_sha256: getarg("sha256"),
    process_args: getarg("argv") | discard_items($config[0].args_discard),
    process_env: (getarg("env") // []) | discard_items($config[0].env_discard) | sort
  } 
