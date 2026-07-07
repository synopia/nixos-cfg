{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.matrix;
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
  networking.hostName = "matrix-vm";

  # environment.systemPackages = with pkgs; [
  #   gh
  #   pwvucontrol
  #   mpv
  #   ffmpeg
  # ];

}
