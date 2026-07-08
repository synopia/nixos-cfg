args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.dm.greetd";

  options = {

  };

  nixos = { cfg, ... }: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "niri-session";
          user = "synopia";
        };
      };
    };
    systemd = {
      settings = {
        Manager = {
          DefaultTimeoutStopSec = "10s";
        };
      };
      services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };
  };
}
