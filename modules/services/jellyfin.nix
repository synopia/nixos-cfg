{
  lib,
  config,
  pkgs,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.services.jellyfin;
in
{
  options.cfg.services.jellyfin.enable = mkEnableOption "jellyfin";
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.jellyfin pkgs.jellyfin-desktop ];
     services.jellyfin = {
       enable = true;
       user="synopia";
       hardwareAcceleration = {
         enable=true;
         type="vaapi";
         device = "/dev/dri/renderD129";
       };

     };
  };
}
