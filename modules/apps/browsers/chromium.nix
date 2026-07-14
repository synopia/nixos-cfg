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
  cfg = config.cfg.apps.browsers.chromium;
in
{
  options.cfg.apps.browsers.chromium = {
    enable = mkEnableOption "Chromium";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ chromium ];
  };
}
