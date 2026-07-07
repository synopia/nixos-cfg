{ pkgs, ... }:

{
  stylix = {
    enable = true;
    polarity = "dark";
    autoEnable = true;
    #    image = ../../wp2975125-future-wallpaper.jpg;
    base16Scheme = {
      variant = "dark";
      slug = "catppuccin-mocha";
      name = "Catppuccin Mocha";
      author = "Catppuccin";
      base00 = "1e1e2e";
      base01 = "181825";
      base02 = "313244";
      base03 = "45475a";
      base04 = "585b70";
      base05 = "cdd6f4";
      base06 = "f5e0dc";
      base07 = "b4befe";
      base08 = "f38ba8";
      base09 = "fab387";
      base0A = "f9e2af";
      base0B = "a6e3a1";
      base0C = "94e2d5";
      base0D = "89b4fa";
      base0E = "cba6f7";
      base0F = "f2cdcd";
    };

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    fonts = {
      monospace = {
        name = "JetBrains Mono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };

      sizes.terminal = 11;
    };
  };
}
