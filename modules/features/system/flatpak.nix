args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "system.flatpak";

  options = {
  };

  nixos = { cfg, ... }: {
    services.flatpak = {
      enable = true;
    };
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    services.flatpak.packages = [
      "org.vinegarhq.Sober"
      "org.gtk.Gtk3theme.adw-gtk3"
      "org.gtk.Gtk3theme.adw-gtk3-dark"
      "org.upscayl.Upscayl"
      # "com.dec05eba.gpu_screen_recorder"
    ];
  };
}
