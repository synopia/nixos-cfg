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
    networking.networkmanager = enabled;
  };
  home = { cfg, ... }: {
    home.packages = with pkgs; [
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
  nixos = {

  };
}
