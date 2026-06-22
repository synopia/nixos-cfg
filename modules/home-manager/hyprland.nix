{ lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland/init.lua;
  };

  xdg.configFile."hypr/config" = {
    source = lib.cleanSource ./hyprland;
    recursive = true;
  };
}
