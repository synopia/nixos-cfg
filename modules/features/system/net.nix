args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "system.net";

  options = {
  };

  nixos = {
    networking.networkmanager = {
      enable = true;
      plugins = [
        pkgs.networkmanager-openvpn
      ];
    };
    security.polkit.enable = true;
    services = {
      # blueman.enable=true;
      # gvfs.enable=true;
      udisks2.enable = true;
      upower.enable = true;
      accounts-daemon.enable = true;

      gnome = {
        glib-networking.enable = true;
        gnome-keyring.enable = true;
        gnome-online-accounts.enable = true;
      };
    };
    systemd.user.services.network-manager-applet = {
      description = "NetworkManager secret agent";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    # systemd.user.services.polkit-gnome-authentication-agent-1 = {
    #   description = "polkit-gnome-authentication-agent-1";
    #   wantedBy = [ "graphical-session.target" ];
    #   wants = [ "graphical-session.target" ];
    #   after = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };
  };
  home = { cfg, ... }: {
    home.packages = with pkgs; [
      coreutils
      polkit_gnome
      networkmanagerapplet
    ];

    home.activation.installOpenVpnCredentials = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -d -m 700 "$HOME/.config/openvpn"

      for file in \
        bishop.localdomain.ovpn \
        ca-cert.pem \
        client-paul.fritsche-cert.pem \
        client-paul.fritsche-key.pem
      do
        source="$HOME/OpenVPN/$file"
        target="$HOME/.config/openvpn/$file"

        if [ -f "$source" ]; then
          $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 600 "$source" "$target"
        fi
      done
    '';
  };
}
