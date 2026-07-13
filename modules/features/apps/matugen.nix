args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "apps.matugen";

  options = {
  };

  nixos = {
    environment.systemPackages = [
      pkgs.matugen
    ];

  };
}
