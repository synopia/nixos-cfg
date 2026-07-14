{
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.services.audio;
in
{
  options.cfg.services.audio = {
    enable = mkEnableOption "Audio (Pipewire+Wireplumber)";
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    hj.packages = with pkgs; [
      alsa-utils
      easyeffects
      pwvucontrol
      qpwgraph
    ];
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    hj.xdg.data.files."wireplumber/scripts/90-steam-recording.lua".source =
      ./wireplumber/90-steam-recording.lua;
    hj.xdg.config.files."wireplumber/wireplumber.conf.d/90-steam-recording.conf".source =
      ./wireplumber/90-steam-recording.conf;

    users.users.${config.cfg.user.name}.extraGroups = [
      "audio"
      "pipewire"
    ];
  };
}
