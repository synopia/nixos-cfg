args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "cli.addons.neofetch";

  options = {
  };

  home = { cfg, ... }: {
    programs.fish = {
      interactiveShellInit = ''
        command -q fastfetch; and fastfetch
      '';
    };

    home.packages = [
      pkgs.fastfetch
    ];
  };
}
