{ pkgs, ... }:
{
  # boot = {
  #   kernelPackages = pkgs.linuxPackages_latest;
  #   loader = {
  #     systemd-boot.enable = true;
  #     efi.canTouchEfiVariables = true;
  #   };
  # };

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    useOSProber = true;
  };
}
