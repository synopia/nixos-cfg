{
  pkgs,
  lib,
  self,
  ...
}:
with lib;
{
  config = {
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
