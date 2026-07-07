args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "system.gaming";

  options = {
  };

  nixos = { cfg, ... }: {
    programs.steam.enable = true;
    zramSwap = {
      enable = true;
      memoryPercent = 50;
    };
  };
}
