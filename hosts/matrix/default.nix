{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.syncon;
{
  imports = [ ./hardware-configuration.nix ];

  environment.systemPackages = with pkgs; [
    gh
    pwvucontrol
    mpv
    ffmpeg
  ];

  syncon.system.hosts.matrix = {
    variant = "dark";
    type = "scheme-neutral";
    wallpaper =
      let
        image = import ./wallpaper.nix;
      in
      syncon.fetchImage image.url image.sha256;
  };

  syncon.system.locale.timeZone = "Europe/Berlin";
  syncon.system.defaultShell = pkgs.fish;

  syncon.cli.git = {
    email = "paul.fritsche@gmail.com";
    name = "Paul Fritsche";
  };

  syncon.desktop = {
    hyprland = enabled;
  };
  syncon.apps = {
    zed = enabled;
  };

  syncon.browsers = {
    brave = disabled;
    chromium = disabled;
    google-chrome = enabled;
    firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        #
      ];
    };
  };
  # flake.nixosConfigurations.matrix = inputs.nixpkgs.lib.nixosSystem {
  #   system = "x86_64-linux";

  #   specialArgs = {
  #     inherit inputs;
  #   };

  #   modules = [
  #     inputs.matugen.nixosModules.default

  #     ./configuration.nix
  #   ];
  # };
}
