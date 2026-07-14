{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
{
  config = {
    services.gnome.gnome-keyring = enabled;
    hj.systemd.services.gnome-keyring = {
      description = "GNOME Keyring Daemon";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "/run/wrappers/bin/gnome-keyring-daemon --start --foreground --component=secrets,pkcs11";
      };
    };
  };
}
