args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.addons.dolphin";

  options = {
  };

  nixos = { cfg, ... }: {
    environment.systemPackages = [
      pkgs.kdePackages.dolphin
    ];
  };
}
