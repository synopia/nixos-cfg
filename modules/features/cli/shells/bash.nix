args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "cli.shells.bash";

  options = {
  };

  forceEnable = config.matrix.cli.defaultShell == "bash";
  nixos = {
    services.envfs.enable = true;
    services.envfs.extraFallbackPathCommands = ''
      ln -s ${pkgs.bash}/bin/bash $out/bash
    '';
  };
  home = { cfg, ... }: {
    programs.bash = {
      enable = true;
    };

    home.packages = [
      pkgs.bash
    ];
  };
}
