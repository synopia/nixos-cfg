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
  cfg = config.cfg.apps.dolphin;
in
{
  options.cfg.apps.dolphin = {
    enable = mkEnableOption "Dolphin (KDE)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.kdePackages.dolphin
    ];
  };
}
