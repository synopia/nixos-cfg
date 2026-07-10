args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "cli.addons.nnn";

  options = {
  };

  home = { cfg, ... }: {
    programs.nnn = enabled;

    home.packages = [
    ];
  };
}
