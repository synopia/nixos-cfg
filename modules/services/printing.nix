{
  config,
  lib,
  pkgs,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.services.printing;
in
{
  options.cfg.services.printing.enable = mkEnableOption "printing";
  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
  };
}
