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
    version = "1.46.0";
    daemonHash = "sha256-axAPZq4+NxzCwWHKGuXyHz/F9VaxNnpSFT0XVlBhWk4=";
    appImageHash = "sha256-6wSWUlACI36ldD68Fon/jn1fqZcJP4uvcoV4CPu7Opo=";
  };
}
