args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "apps.browsers.google-chrome";

  nixos = {
    environment.systemPackages = with pkgs; [ google-chrome ];
  };
}
