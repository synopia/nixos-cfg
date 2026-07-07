args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop";

  options = {
    terminal = mkOpt types.str "kitty" "Default terminal";
  };

  nixos = { cfg, ... }: {
  };
}
