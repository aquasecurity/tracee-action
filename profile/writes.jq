def getarg(name): .args[] | select(.name == name) | .value;

[
  .[] | 
  select(.eventName=="file_write") | 
  getarg("pathname") |
  ltrimstr($github_workspace + "/")
] | unique
