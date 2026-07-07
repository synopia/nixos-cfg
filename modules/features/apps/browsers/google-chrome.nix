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

  nixos = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ google-chrome ];
  };
}
