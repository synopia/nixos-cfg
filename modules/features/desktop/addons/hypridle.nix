args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.addons.hypridle";

  options = {
  };

  home = { cfg, ... }: {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          inhibit_sleep = 3;
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600;
            on-resume = "hyprctl dispatch dpms on";
            on-timeout = "hyprctl dispatch dpms off";
          }
          {
            timeout = 900;
            on-timeout = "systemctl suspend || loginctl suspend";
          }
        ];
      };
    };
  };
}
