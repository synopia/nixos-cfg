{
  inputs,
  config,
  default,
  ...
}:
let
  cfgdir = "${config.home.homeDirectory}/.config";
in
{
  imports = [
    inputs.matugen.nixosModules.default
  ];

  home.file."matugen/templates" = {
    source = ./templates;
    target = "${cfgdir}/matugen/templates";
    recursive = true;
  };

  home.file.".config/matugen/config.toml".text = ''
    [config]

    [templates.quickshell]
    input_path = '/home/synopia/nixos-config/modules/home-manager/matugen/templates/quickshell.json'
    output_path = '~/.local/state/quickshell/generated/colors.json'

    [templates.kitty]
    input_path = "/home/synopia/nixos-config/modules/home-manager/matugen/templates/kitty-colors.conf"
    output_path = "~/.config/kitty/themes/matugen.conf"
    post_hook = "kitty +kitten themes --dump-theme=yes --reload-in=all matugen &> /dev/null"

    [templates.rofi]
    input_path = '/home/synopia/nixos-config/modules/home-manager/matugen/templates/rofi-colors.rasi'
    output_path = '~/.config/rofi/colors.rasi'
  '';
  programs.matugen = {
    enable = true;
    variant = "dark";
    jsonFormat = "hex";
    type = "scheme-tonal-spot";

    # inherit wallpaper;

    # templates = matugenTemplates;
  };
}
