args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.addons.rofi";

  options = {

  };

  home =
    { cfg, config, ... }:
    let
      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          "@import" = "colors.rasi";
          "*" = {
            # background-color = mkLiteral "@surface";
            # text-color = mkLiteral "@on-surface";
            # font = "Iosevka Nerd Font 16";
          };
          "window" = {
            anchor = mkLiteral "center";
            location = mkLiteral "center";
            padding = mkLiteral "4px";
            width = mkLiteral "20em";
            children = map mkLiteral [
              "horibox"
            ];
            # background-color = mkLiteral "@surface";
          };
          "horibox" = {
            orientation = mkLiteral "vertical";
            children = map mkLiteral [
              "prompt"
              "entry"
              "listview"
            ];
          };
          "listview" = {
            layout = mkLiteral "vertical";
            spacing = mkLiteral "5px";
            lines = mkLiteral "10";
          };
          "entry" = {
            expand = false;
            cursor = mkLiteral "pointer";
            width = mkLiteral "10em";
          };
          "element" = {
            orientation = mkLiteral "horizontal";
            spacing = mkLiteral "5px";
            children = map mkLiteral [
              "element-text"
              "element-icon"
            ];
          };

          "element-icon" = {
            size = "25em";
          };

          "element selected" = {
            # background-color = mkLiteral "@primary";
            # text-color = mkLiteral "@on-primary";
          };

          "element-text, element-icon" = {
            vertical-align = mkLiteral "0.5";
            # background-color = mkLiteral "inherit";
            # text-color = mkLiteral "inherit";
          };
        };
    in
    {
      programs.rofi = {
        enable = true;
        modes = [ "drun" ];
        extraConfig = {
          show-icons = true;
          icon-theme = "Papirus-Dark";
          drun-display-format = "{name}";
        };
        theme = theme;

      };
    };
}
