# getarg returns the value of the argument with the given name from a Tracee execution event
def getarg(name): .args[] | select(.name == name) | .value;

# discard_items discards all items in the input array of strings that matches any of the regular expressions in the patterns array of strings
def discard_items(patterns): if patterns | length > 0 then map(select([test(patterns[])] | any | not)) else . end;

# discard_items_pairs discards all pairs of items in the input array of strings that the first element in the pair matches any of the regular expressions in the patterns array of strings
def discard_items_pairs(patterns): if patterns | length > 0 then delpaths([paths([test(patterns[])] | any) | .,map(.+1)]) else . end;

[
  .[] | 
  { 
    user_id: .userId,
    process_name: .processName,
    binary_path: getarg("pathname"),
    binary_sha256: getarg("sha256"),
    process_args: getarg("argv") | discard_items_pairs($config[0].args_discard_pair) | discard_items($config[0].args_discard),
    process_env: (if isempty(getarg("env")) | not then (discard_items($config[0].env_discard) | sort) else null end)
  } 
] | sort_by(.binary_path)
