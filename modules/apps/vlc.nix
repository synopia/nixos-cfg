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
  cfg = config.cfg.apps.vlc;
in
{
  options.cfg.apps.vlc = {
    enable = mkEnableOption "vlc";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vlc
    ];
  };
}
