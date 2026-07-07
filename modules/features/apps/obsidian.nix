args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "apps.obsidian";

  options = {
  };
  home = { cfg, ... }: {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
