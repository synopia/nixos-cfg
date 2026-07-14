{
  pkgs,
  config,
  self,
  lib,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.desktop.noctalia-theming.gtk;
in
{
  options.cfg.desktop.noctalia-theming.gtk = {
    enable = mkEnableOption "Noctalia Theming (GTK)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      adw-gtk3
      nwg-look
      kdePackages.breeze
      kdePackages.breeze-icons
      glib
      gsettings-desktop-schemas
      gtk3.dev
      gtk4.dev
      # pinta
    ];
    hj = {
      # xdg.config.files."gtk-4.0/gtk.css".text = ''
      #   @import 'colors.css';
      # '';
      # xdg.config.files."gtk-3.0/gtk.css".text = ''
      #   @import 'colors.css';
      # '';
    };
    environment.sessionVariables = {
      GTK_THEME = "adw-gtk3:dark";
      GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    };
    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "adw-gtk3";
            icon-theme = "breeze-dark";
            font-name = "Noto Regular 11";
            document-font-name = "Noto Regular 11";
            monospace-font-name = "JetBrains Mono Regular 12";
            color-scheme = "prefer-dark";
            gtk-enable-primary-paste = false;
            enable-animations = config.cfg.user.smoothScroll;
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = ":";
          };
        };
      }
    ];
  };
}
