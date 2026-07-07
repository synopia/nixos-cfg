{
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
  networking.hostName = "matrix-vm";

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    useOSProber = true;
  };
  # environment.systemPackages = with pkgs; [
  #   gh
  #   pwvucontrol
  #   mpv
  #   ffmpeg
  # ];

}
