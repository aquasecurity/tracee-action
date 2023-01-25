def getarg(name): .args[] | select(.name == name) | .value;

def discard_items(dns): if dns | length > 0 then map(select([startswith(dns[])] | any | not)) else . end;

[
  .[] | getarg("proto_dns").questions[].name 
] | discard_items($config[0].dns_discard) | unique
