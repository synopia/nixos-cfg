{ pkgs, config, ... }:
let
  noctalia =
    cmd:
    [
      "noctalia"
      "msg"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  programs.niri = {
    settings = {
      binds = with config.lib.niri.actions; {
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
        "Mod+Shift+Ctrl+D".action = debug-toggle-damage;
        "Mod+Space".action.spawn = noctalia "panel-toggle launcher";
        "Mod+Q".action = close-window;
        "Mod+W".action = spawn "google-chrome";
        "Mod+Return".action = spawn "kitty";
        "Mod+E".action = spawn "dolphin";
        "Mod+Z".action = spawn "zeditor";

        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-workspace-down;
        "Mod+Up".action = focus-workspace-up;

        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Down".action = move-column-to-workspace-down;
        "Mod+Shift+Up".action = move-column-to-workspace-up;

        "Mod+1".action = focus-workspace "main";
        "Mod+2".action = focus-workspace "browser";
        "Mod+3".action = focus-workspace "discord";

        "Mod+Shift+S".action.screenshot = { };
        "Mod+S".action = set-dynamic-cast-monitor;
      };
    };
  };
}
