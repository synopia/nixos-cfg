{
  pkgs,
  lib,
  self,
  config,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.desktop.niri;
  noctalia =
    cmd:
    [
      "noctalia"
      "msg"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  options.cfg.desktop.niri = {
    enable = mkEnableOption "niri";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      kdePackages.breeze

    ];
    programs.niri = enabled;
    hj.rum.desktops.niri = {
      enable = true;

      binds = {
        "Mod+R" = {
          action = "switch-preset-column-width";
        };
        "Mod+F" = {
          action = "maximize-window-to-edges";
        };
        "Mod+Shift+F" = {
          action = "fullscreen-window";
        };
        "Mod+Space" = {
          spawn = noctalia "panel-toggle launcher";
        };
        "Mod+Q" = {
          action = "close-window";
        };
        "Mod+W" = {
          spawn = [ "google-chrome" ];
        };
        "Mod+E" = {
          spawn = [ "dolphin" ];
        };
        "Mod+Z" = {
          spawn = [ "zeditor" ];
        };
        "Mod+Return" = {
          spawn = [ "kitty" ];
        };
        "Mod+T" = {
          spawn = [ "kitty" ];
        };

        "Mod+Left" = {
          action = "focus-column-or-monitor-left";
        };
        "Mod+Right" = {
          action = "focus-column-or-monitor-right";
        };
        "Mod+Down" = {
          action = "focus-window-or-workspace-down";
        };
        "Mod+Up" = {
          action = "focus-window-or-workspace-up";
        };

        "Mod+Shift+Left" = {
          action = "move-column-left-or-to-monitor-left";
        };
        "Mod+Shift+Right" = {
          action = "move-column-right-or-to-monitor-right";
        };
        "Mod+Shift+Down" = {
          action = "move-window-down-or-to-workspace-down";
        };
        "Mod+Shift+Up" = {
          action = "move-window-up-or-to-workspace-up";
        };

        # "Mod+1" = {
        #   action = [
        #     "focus-workspace"
        #     "1-obsidian"
        #   ];
        # };
        # "Mod+2" = {
        #   action = [
        #     "focus-workspace"
        #     "2-discord"
        #   ];
        # };
        # "Mod+3" = {
        #   action = [
        #     "focus-workspace"
        #     "3-loa-logs"
        #   ];
        # };
        # "Mod+4" = {
        #   action = [
        #     "focus-workspace"
        #     "1-main"
        #   ];
        # };

        "Mod+Comma" = {
          action = "consume-or-expel-window-left";
        };
        "Mod+Period" = {
          action = "consume-or-expel-window-right";
        };

        "Mod+Shift+S" = {
          action = "screenshot";
        };
        "Mod+S" = {
          action = "set-dynamic-cast-monitor";
        };

      };
      spawn-at-startup = [
        [ "xwayland-satellite" ]
        [ "kitty" ]
        [ "vesktop" ]
        [ "karere" ]
        [ "obsidian" ]
        [ "loa-logs" ]
        [
          "steam"
          "-silent"
        ]
        [
          "jetbrains-toolbox"
          "-s"
        ]
      ];
      extraVariables = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
      };
      config = (
        lib.concatMapStringsSep "\n" builtins.readFile [
          ./niri/rules.kdl
          ./niri/settings.kdl
        ]
      );
    };
  };
}
