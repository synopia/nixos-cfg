args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "dev.vmhost";

  options = {
  };

  nixos = { cfg, ... }: {
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ config.matrix.user.name ];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd = {
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };
}
