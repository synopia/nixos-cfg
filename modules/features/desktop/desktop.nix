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
    fonts = {
      enableDefaultPackages = false;
      fontconfig = {
        subpixel = {
          rgba = mkDefault "rgb";
          lcdfilter = "light";
        };
        hinting.style = "slight";
        antialias = true;
        includeUserConf = false;
        useEmbeddedBitmaps = true;

        enable = true;
        defaultFonts = {
          serif = [ "Noto Serif" ];
          sansSerif = [ "Inter" ];
          monospace = [
            "JetBrains Mono"
            "Symbols Nerd Font"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
      packages = with pkgs; [
        nerd-fonts.symbols-only
        jetbrains-mono
        nerd-fonts.jetbrains-mono
        inter
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-cjk-sans

        corefonts
        vista-fonts
      ];
    };
  };
}
