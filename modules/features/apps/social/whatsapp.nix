args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "apps.discord.whatsapp";

  options = {
  };
  home = { cfg, ... }: {
    home.packages = with pkgs; [
      karere
    ];
  };
}
