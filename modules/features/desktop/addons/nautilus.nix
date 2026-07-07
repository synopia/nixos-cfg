args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.addons.nautilus";

  options = {
  };

  nixos = { cfg, ... }: {
    environment.systemPackages = with pkgs; [
      nautilus
      libheif # thumbnails
      libheif.out
      loupe # images
    ];
    environment.pathsToLink = [ "share/thumbnailers" ];
    # services.gvfs = enabled;
    services.udisks2 = enabled;
  };
}
