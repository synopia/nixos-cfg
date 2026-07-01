{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos

    ./users.nix

    inputs.home-manager.nixosModules.home-manager

  ];
  # catppuccin = {
  # enable = true;
  # autoEnable = true;
  # gtk.icon.enable = true;
  # };
  services.dbus.implementation = "broker";
  services.systembus-notify.enable = true;

  networking.hostName = "matrix";
  networking.networkmanager.enable = true;

  system.stateVersion = "26.05";
  home-manager = {

    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;
    };

    users.synopia = import ../../home/synopia;

  };

  services.loa-logs = {
    enable = true;
    version = "1.47.0";
    daemonHash = "sha256-AH/o0rRVSuLg9Ex7wDE5f7r17qghnf/lOFdibG4YZ1g=";
    appImageHash = "sha256-kZ5gUee3oCLeHDtKza22MciEjuvjEj0Sq3p5m8Oxc3c=";
  };
}
