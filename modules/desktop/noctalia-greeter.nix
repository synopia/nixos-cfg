{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.desktop.noctalia-greeter;
in
{
  options.cfg.desktop.noctalia-greeter = {
    enable = mkEnableOption "Noctalia greeter";
  };

  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bibata-cursors
    ];
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
