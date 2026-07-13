args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "cli.addons.yazi";

  options = {
  };

  home = { cfg, ... }: {
    programs.yazi = enabled;

    home.packages = [
    ];
  };
}
