{
  pkgs,
  config,
  self,
  lib,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.apps.pinta;
in
{
  options.cfg.apps.pinta = {
    enable = mkEnableOption "pinta";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pinta
    ];
  };
}
