{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    corepack_22

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

    qt5.qtbase
    qt5.qtbase.bin
    qt5.qtdeclarative
    qt5.qtdeclarative.bin
    # qt5.qttools
    # qt5.qttools.bin
    qt5.qtwayland

    jetbrains.idea
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
