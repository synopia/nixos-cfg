{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/stylix.nix
    ../../modules/core/boot.nix
    ../../modules/core/user.nix
    ../../modules/features
    ../../users/synopia.nix
  ];
  system.stateVersion = "26.05";
  networking.hostName = "matrix";
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

}
