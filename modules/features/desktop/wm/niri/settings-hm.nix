{ pkgs, ... }:
{
  programs.niri = {
    settings = {
      workspaces = {
        "1-obsidian" = {
          open-on-output = "HDMI-A-1";
        };
        "2-discord" = {
          open-on-output = "HDMI-A-1";
        };
        "3-loa-logs" = {
          open-on-output = "HDMI-A-1";
        };
        "1-main" = {
          open-on-output = "DP-3";
        };
      };
      prefer-no-csd = true;
      cursor = {
        theme = "Bibata-Original-Amber";
        size = 24;
      };
      hotkey-overlay = {
        skip-at-startup = true;
      };
      overview = {
        workspace-shadow.enable = false;
      };

      layout = {

        background-color = "transparent";

        focus-ring = {
          enable = true;
          width = 3;
          active = {
            color = "#A8AEFF";
          };
          inactive = {
            color = "#505050";
          };
        };

        gaps = 6;

        struts = {
          left = 10;
          right = 10;
          top = 10;
          bottom = 10;
        };
      };

      input = {
        keyboard.xkb = {
          variant = "intl";
          layout = "us";
        };
        focus-follows-mouse.enable = true;
        warp-mouse-to-focus.enable = false;
      };
      outputs = {
        "DP-3" = {
          mode = {
            width = 1920;
            height = 1080;
          };
          scale = 1.0;
          position = {
            x = 1920;
            y = 0;
          };
          focus-at-startup = true;
        };
        "HDMI-A-1" = {
          mode = {
            width = 1920;
            height = 1080;
          };
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
        };
      };
      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
        DISPLAY = ":0";
      };
    };
  };
}
