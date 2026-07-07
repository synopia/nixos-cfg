args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "cli.shells.zsh";

  options = {
  };

  forceEnable = config.matrix.cli.defaultShell == "zsh";
  home = { cfg, ... }: {
    programs.zsh = {
      enable = true;
    };

    home.packages = [
      pkgs.zsh
    ];
  };
}
