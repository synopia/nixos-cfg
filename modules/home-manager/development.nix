{ pkgs, ... }:
{
  home.packages = with pkgs; [
    corepack_22

    # Provides psql, pg_dump, createdb, and other PostgreSQL client tools.
    postgresql_17
    pgcli

    docker-compose
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
