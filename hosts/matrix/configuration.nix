{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos

    ./users.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    autoEnable = true;
    gtk.icon.enable = true;
    # flavor = "latte";
  };
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
}
