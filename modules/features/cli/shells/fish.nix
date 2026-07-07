args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "cli.shells.fish";

  options = {
  };

  forceEnable = config.matrix.cli.defaultShell == "fish";
  home = { cfg, ... }: {
    programs.fish = {
      enable = true;
    };

    home.packages = [
      pkgs.fish
    ];
  };
}
