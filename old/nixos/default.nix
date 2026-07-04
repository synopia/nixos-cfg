{ nixpkgs, ... }:
{
  imports = [
    ./nix.nix
    ./boot.nix
    ./locale.nix
    # ./stylix.nix
    ./sddm.nix
    ./hyprland.nix
    ./audio.nix
    ./printing.nix
    ./development.nix
    ./flatpak.nix
    ./gaming.nix
    ./loa-logs.nix
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
  ];
}
