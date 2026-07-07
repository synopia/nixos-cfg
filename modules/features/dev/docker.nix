args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "dev.docker";

  options = {
  };

  nixos = { cfg, ... }: {
    virtualisation.docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };

      # Periodically remove unused layers while retaining recent build cache.
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--filter=until=168h" ];
      };
    };
  };
}
