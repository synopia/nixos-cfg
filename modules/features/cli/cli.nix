args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "cli";

  options = {
    defaultShell = mkOpt types.str "fish" "Default shell";
  };

  nixos = { cfg, ... }: {
  };
}
