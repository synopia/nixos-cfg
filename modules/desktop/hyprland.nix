{
  config,
  pkgs,
  lib,
  inputs,
  options,
  default,
  hostName,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.desktop.hyprland;
  wallpaper =
    if builtins.hasAttr "wallpaper" options.syncon.system.hosts.${hostName} then
      config.syncon.system.hosts.${hostName}.wallpaper
    else
      default.wallpaper;
in
{
  options.syncon.desktop.hyprland = {
    enable = mkBoolOpt false "Whether to enable Hyprland";

  };

  imports = [
    inputs.hyprland.nixosModules.default
  ];

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      plugins = [ ];
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-wlr
      ];
      config = {
        hyprland.default = [
          "hyprland"
          "gtk"
        ];
        common.default = [ "gnome" ];
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      USE_WAYLAND = "1";
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      wl-clip-persist
      cliphist
      playerctl
      inputs.nixpkgs-wayland.packages.${stdenv.hostPlatform.system}.wl-gammarelay-rs
      wf-recorder
      awww

      hyprshot
      hyprpicker

      adwaita-icon-theme
      hicolor-icon-theme
      imagemagick
      nwg-look
      bibata-cursors

    ];

    syncon.desktop.addons = {
      kitty = enabled;
      rofi = enabled;
      gtk = enabled;
      nautilus = enabled;
      qt = enabled;
      quickshell = enabled;
      sddm = enabled;
    };

    syncon.cli = {
      neofetch = enabled;
      starship = enabled;
    };

    syncon.services = {
      flatpak = enabled;
    };

  };
}
