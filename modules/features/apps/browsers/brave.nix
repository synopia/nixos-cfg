args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "apps.browsers.brave";

  nixos = {
    environment.systemPackages = with pkgs; [ brave ];
  };
}
