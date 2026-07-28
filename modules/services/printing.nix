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

    hardware.printers = {
      ensurePrinters = [
        {
          name = "HP_DeskJet_2920";
          description = "HP DeskJet 2920";
          location = "Home";
          deviceUri = "ipp://192.168.178.23/ipp/print";
          model = "everywhere";
        }
      ];
      ensureDefaultPrinter = "HP_DeskJet_2920";
    };
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
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
