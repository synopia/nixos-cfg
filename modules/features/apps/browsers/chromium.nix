args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "apps.browsers.chromium";

  nixos = {
    environment.systemPackages = with pkgs; [ chromium ];
  };
}
