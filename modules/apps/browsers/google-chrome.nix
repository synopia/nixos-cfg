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
  cfg = config.cfg.apps.browsers.google-chrome;
in
{
  options.cfg.apps.browsers.google-chrome = {
    enable = mkEnableOption "Google Chrome";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ google-chrome ];
  };
}
