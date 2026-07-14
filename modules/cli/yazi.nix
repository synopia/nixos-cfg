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
  cfg = config.cfg.cli.yazi;
in
{
  options.cfg.cli.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.yazi ];
    hj.rum.programs.yazi = enabled;
  };
}
