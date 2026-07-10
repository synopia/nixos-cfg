args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop";

  options = {
    browser = mkOpt types.str "google-chrome" "Default browser";
    terminal = mkOpt types.str "kitty" "Default terminal";
    fileManager = mkOpt types.str "nautilus" "Default fileManager";
    editor = mkOpt types.str "zeditor" "Default editor";
  };

  nixos = { cfg, ... }: {
    environment.systemPackages = [
      pkgs.vlc
      pkgs.clapper
    ];
  };
}
