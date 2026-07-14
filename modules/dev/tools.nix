{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.dev.tools;
in
{
  options.cfg.dev.tools = {
    enable = mkEnableOption "Tools";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "pnpm-10.29.2"
    ];
    environment.systemPackages = [
      pkgs.python3
    ];
    hj.packages = with pkgs; [
      devenv
      neovim

      gzip
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      nodejs_22
      corepack_22
      python3

      sqlite
      postgresql_17
      pgcli

      docker-compose

      qt6.qtbase
      qt6.qtdeclarative # Provides qmlls, qmlformat, qmllint, qmlscene, and other QML tools.
      qt6.qtshadertools
      qt6.qttools
      qt6.qtwayland
      qt6.qt5compat

      (lib.lowPrio qt5.qtbase)
      (lib.lowPrio qt5.qtbase.bin)
      (lib.lowPrio qt5.qtdeclarative)
      (lib.lowPrio qt5.qtdeclarative.bin)
      (lib.lowPrio qt5.qttools)
      (lib.lowPrio qt5.qttools.bin)
      (lib.lowPrio qt5.qtwayland)

      jetbrains-toolbox
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
