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
  cfg = config.cfg.dev.docker;
in
{
  options.cfg.dev.docker = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
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
