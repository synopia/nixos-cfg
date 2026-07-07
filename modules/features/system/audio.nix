args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "system.audio";

  options = {
  };

  nixos = { cfg, ... }: {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    environment.systemPackages = with pkgs; [
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
  };

  home = {
    xdg.dataFile."wireplumber/scripts/90-steam-recording.lua".source =
      ./wireplumber/90-steam-recording.lua;
    xdg.configFile."wireplumber/wireplumber.conf.d/90-steam-recording.conf".source =
      ./wireplumber/90-steam-recording.conf;
  }
}
