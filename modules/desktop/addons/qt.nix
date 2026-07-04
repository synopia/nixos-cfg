{
  config,
  pkgs,
  lib,
  inputs,
  default,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.desktop.addons.qt;
in
{
  options.syncon.desktop.addons.qt = with types; {
    enable = mkBoolOpt false "Whether to enable qt.";
  };

  config = mkIf cfg.enable {
    environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";
    qt.enable = true;
    environment.systemPackages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      kdePackages.qt6ct
      kdePackages.breeze
      kdePackages.breeze-icons
      kdePackages.breeze-gtk
    ];
  };
}
