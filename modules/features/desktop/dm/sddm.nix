args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.dm.sddm";

  options = {

  };

  nixos = { cfg, ... }: {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
          compositor = "kwin";
        };
        autoNumlock = true;
      };
    };
  };
}
