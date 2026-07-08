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
    matrix.desktop.dm.greetd = enabled;
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      bibata-cursors
      nwg-look
      adw-gtk3
    ];
  };
  home = { config, ... }: {
    imports = [
      inputs.niri.homeModules.niri
      inputs.noctalia.homeModules.default
      ./niri/autostart-hm.nix
      ./niri/keybinds-hm.nix
      ./niri/rules-hm.nix
      ./niri/settings-hm.nix
    ];

    programs.noctalia = enabled;

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };
  };
}
