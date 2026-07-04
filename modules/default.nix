{
  lib,
  ...
}:
with lib.syncon;
{
  imports = [ ./cli/git.nix ] ++ validFiles ./.;
}
