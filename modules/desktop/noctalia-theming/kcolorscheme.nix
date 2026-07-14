{
  pkgs,
  config,
  self,
  lib,
  inputs,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.desktop.noctalia-theming.kde;
in
{
  options.cfg.desktop.noctalia-theming.kde = {
    enable = mkEnableOption "Noctalia Theming (KDE Plasma)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.kate
    ];
  };
}
