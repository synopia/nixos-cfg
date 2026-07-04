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
  cfg = config.syncon.desktop.addons.nautilus;
in
{
  options.syncon.desktop.addons.nautilus = with types; {
    enable = mkBoolOpt false "Whether to enable nautilus.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nautilus
      # for thumbnails
      libheif
      libheif.out
      # for images
      loupe
    ];

    environment.pathsToLink = [ "share/thumbnailers" ];
    services.gvfs.enable = true;
    services.udisks2.enable = true;
  };
}
