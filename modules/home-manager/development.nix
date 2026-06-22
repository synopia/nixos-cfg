{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    corepack_22

    # Provides psql, pg_dump, createdb, and other PostgreSQL client tools.
    postgresql_17
    pgcli

    docker-compose

    jetbrains.idea
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
