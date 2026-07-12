{
  pkgs,
  inputs,
  nixos,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    #   ../../modules/core/stylix.nix
    #   ../../modules/core/boot.nix
    #   ../../modules/core/user.nix
    #   ../../modules/features
    ../../users/synopia.nix

  ];
  system.stateVersion = "26.05";
  networking.hostName = "matrix";
  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  programs.niri.enable = true;
  programs.noctalia-greeter = {
    enable = true;
    greeter-args = "";
    settings = {
      cursor = {
        theme = "Bibata-Original-Amber";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
      keyboard = {
        layout = "us";
        variant = "intl";
      };
    };
  };
  users.mutableUsers = true;
  users.users.synopia = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ];

    initialPassword = "test";
  };
  hjem = {
    extraModules = [
      inputs.hjem-rum.hjemModules.default
    ];

  };
}
