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
  cfg = config.cfg.apps.steam;
in
{
  options.cfg.apps.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mediainfo mkvtoolnix ];
    programs.gpu-screen-recorder = enabled;
    programs.steam = enabled;
    programs.gamescope = enabled;
  };
}
