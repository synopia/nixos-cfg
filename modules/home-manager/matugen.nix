{ inputs, config, ... }:
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

  '';
  programs.matugen.enable = true;
}
