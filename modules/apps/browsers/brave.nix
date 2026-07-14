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
  cfg = config.cfg.apps.browsers.brave;
in
{
  options.cfg.apps.browsers.brave = {
    enable = mkEnableOption "Brave";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ brave ];
  };
}
