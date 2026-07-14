{
  pkgs,
  lib,
  config,
  inputs,
  self,
  ...
}:
with lib;
with self.lib;
let
in
{
  imports = [
    inputs.matugen.nixosModules.default
  ];

  config = {
    environment.systemPackages = with pkgs; [
      inputs.matugen.packages.${stdenv.hostPlatform.system}.default
    ];

    hj.xdg.config.files."matugen/config.toml".source = ./matugen/config.toml;
    hj.xdg.config.files."matugen/templates".source = ./matugen/templates;
  };
}
