{
  pkgs,
  lib,
  ...
}:
with lib;
{
  options = {
    cfg.core = {
      isLaptop = mkEnableOption "laptop";
      isVM = mkEnableOption "vm";
    };
  };
  config = {
    console = {
      earlySetup = true;
      packages = [ pkgs.terminus_font ];
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
    };

    boot = {
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
        "ntsync"
        "preempt=full"
      ];

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
