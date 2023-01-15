def getarg(name): .args[] | select(.name == name) | .value;

[
  .[] | getarg("proto_dns").questions[].name
] | unique
