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
  '';
  programs.matugen.enable = true;
}
