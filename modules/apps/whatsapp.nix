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
  cfg = config.cfg.apps.whatsapp;
in
{
  options.cfg.apps.whatsapp = {
    enable = mkEnableOption "Whatsapp (Karere)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      karere
    ];
  };
}
