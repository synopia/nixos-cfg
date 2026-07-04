{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    corepack_22
    python3

    # Provides psql, pg_dump, createdb, and other PostgreSQL client tools.
    postgresql_17
    pgcli

    docker-compose

    qtcreator

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
    jetbrains.idea
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
