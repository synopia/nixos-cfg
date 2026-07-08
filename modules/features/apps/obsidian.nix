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
    # stylix.targets.obsidian.colors.enable = true;
    # stylix.targets.obsidian.enable = true;
    # stylix.targets.obsidian.vaultNames = [
    #   "main"
    #   "main.main"
    #   "main/main"
    # ];
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
