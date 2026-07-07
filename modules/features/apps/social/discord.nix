args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "apps.social.discord";

  options = {
  };
  home = { cfg, ... }: {
    home.packages = with pkgs; [
      vesktop
    ];
  };
}
