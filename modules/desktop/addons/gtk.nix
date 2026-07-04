{
  config,
  pkgs,
  lib,
  inputs,
  default,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.desktop.addons.gtk;
  schema = pkgs.gsettings-desktop-schemas;
  datadir = "${schema}/share/gsettings-schemas/${schema.name}";
  reload-theme = pkgs.writeShellScriptBin "reload-theme" ''
    export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
    gsettings set org.gnome.desktop.interface gtk-theme ""
    sleep 0.1
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
  '';
in
{
  options.syncon.desktop.addons.gtk = with types; {
    enable = mkBoolOpt false "Whether to enable gtk theme.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lxappearance-gtk2
      libadwaita
      gsettings-desktop-schemas
      reload-theme
    ];
    syncon.home.extraOptions.gtk.enable = true;
  };
}
