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
  name = "desktop.wm.niri";

  nixos = {
    programs.niri = enabled;
    matrix.desktop.dm.noctalia-greeter = enabled;
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      bibata-cursors
      nwg-look
      adw-gtk3
    ];
  };
  home = {
    imports = [
      inputs.niri.homeModules.niri
      inputs.noctalia.homeModules.default
      ./niri/autostart-hm.nix
      ./niri/keybinds-hm.nix
      ./niri/rules-hm.nix
      ./niri/settings-hm.nix
    ];

    programs.noctalia = {
      enable = true;
      systemd = enabled;
      settings = {
        themes.templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "btop"
            "gtk3"
            "gtk4"
            "kcolorscheme"
            "kitty"
            "niri"
            "starship"
            "qt"
          ];
          enable_community_templates = true;
          community_ids = [
            "obsidian"
            "zed"
            "discord"
            "steam"
          ];
        };
      };
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };
  };
}
