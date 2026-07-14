{
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.apps.kitty;
in
{
  options.cfg.apps.kitty = {
    enable = mkEnableOption "kitty";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kitty ];
    hj.rum.programs.kitty = enabled;
  };
}
