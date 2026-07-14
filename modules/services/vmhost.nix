{
  lib,
  config,
  pkgs,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.services.vmhost;
in
{
  options.cfg.services.vmhost.enable = mkEnableOption "libvirtd / virt-manager";
  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    programs.virt-manager.enable = true;
    users.users.${config.cfg.core.username}.extraGroups = [ "libvirtd" ];
    virtualisation.libvirtd = {
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
    environment.systemPackages = with pkgs; [
      dnsmasq
    ];
  };
}
