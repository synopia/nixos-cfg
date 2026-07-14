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
  cfg = config.cfg.apps.nautilus;
in
{
  options.cfg.apps.nautilus = {
    enable = mkEnableOption "Nautilus (GTK)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nautilus
      libheif # thumbnails
      libheif.out
      loupe # images
    ];
    environment.pathsToLink = [ "share/thumbnailers" ];
    # services.gvfs = enabled;
    # TODO services.udisks2 = enabled;
  };
}
