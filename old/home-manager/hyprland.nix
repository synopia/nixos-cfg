{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    grim # screenshots
    slurp # region selection
    wl-clipboard # Wayland clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland/init.lua;
  };

  xdg.configFile."hypr/config" = {
    source = lib.cleanSource ./hyprland;
    recursive = true;
  };
}
