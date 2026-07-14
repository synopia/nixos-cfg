{
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.core.networkmanager;
in
{
  options.cfg.core.networkmanager = {
    enable = mkEnableOption "NetworkManager";
  };

  config = mkIf cfg.enable {
    programs.nm-applet = enabled;
    networking = {
      networkmanager = {
        enable = true;
        wifi.powersave = config.cfg.core.isLaptop;
        plugins = [ pkgs.networkmanager-openvpn ];
      };
    };
    users.users.${config.cfg.user.name} = {
      extraGroups = [ "networkmanager" ];
    };
  };
}
