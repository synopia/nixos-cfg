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
  name = "desktop.wm.hyprland";

  options = {
    enableXWayland = mkBoolOpt true "Enable XWayland support.";
    terminal = mkOpt types.str "kitty" "Default terminal command.";
    useUWSM = mkBoolOpt true "Hyprland uses UWSM.";
  };

  nixos = { cfg, ... }: {
    programs.uwsm = {
      enable = cfg.useUWSM;
    };
    matrix.desktop.dm.sddm = enabled;

    programs.hyprland = {
      enable = true;
      xwayland.enable = cfg.enableXWayland;

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = cfg.useUWSM;
    };

    security.polkit.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      USE_WAYLAND = "1";
    };
    environment.systemPackages = with pkgs; [
      wl-clipboard
      grim
      slurp
      hyprshot
      hyprpicker

      adwaita-icon-theme
      hicolor-icon-theme
      imagemagick
      nwg-look
      bibata-cursors
    ];
  };

  home = { cfg, ... }: {
    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config.hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        "org.freedesktop.impl.portal.GlobalShortcuts" = [ "hyprland" ];
      };
    };

    xdg.configFile."hypr/config" = {
      source = lib.cleanSource ./hyprland;
      recursive = true;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      settings = {

      };
      extraConfig = builtins.readFile ./hyprland/init.lua;
    };
  };
}
