{
  lib,
  ...
}:
with lib.syncon;
{
  imports = validFiles ./.;
}
