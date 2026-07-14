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
  cfg = config.cfg.apps.pdfarranger;
in
{
  options.cfg.apps.pdfarranger = {
    enable = mkEnableOption "pdfarranger";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pdfarranger
    ];
  };
}
