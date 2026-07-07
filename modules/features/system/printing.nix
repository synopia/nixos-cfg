args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "system.printing";

  options = {
  };

  nixos = { cfg, ... }: {
    services.printing.enable = true;
  };
}
