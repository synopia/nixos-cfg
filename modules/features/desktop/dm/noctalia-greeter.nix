args@{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.dm.noctalia-greeter";

  options = {

  };

  nixos = { cfg, ... }: {

    programs.noctalia-greeter = {
      enable = true;
      greeter-args = "";
      settings = {
        cursor = {
          theme = "Bibata-Original-Amber";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
        keyboard = {
          layout = "us";
          variant = "intl";
        };
      };
    };
  };
}
