args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.addons.qt";

  options = {
  };

  nixos = { cfg, ... }: {
    # environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";
    qt = enabled;

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
