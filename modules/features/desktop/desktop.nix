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
    fileManager = mkOpt types.str "nautilus" "Default fileManager";
  };

  nixos = { cfg, ... }: {
    environment.systemPackages = [
      pkgs.vlc
      pkgs.clapper
    ];
  };
}
