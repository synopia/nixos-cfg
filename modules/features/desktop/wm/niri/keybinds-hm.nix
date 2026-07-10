{
  pkgs,
  config,
  osConfig,
  ...
}:
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
        "Mod+R".action = switch-preset-column-width;
        "Mod+F".action = maximize-window-to-edges;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Space".action.spawn = noctalia "panel-toggle launcher";
        "Mod+Q".action = close-window;
        "Mod+W".action = spawn osConfig.matrix.desktop.browser;
        "Mod+Return".action = spawn osConfig.matrix.desktop.terminal;
        "Mod+E".action = spawn osConfig.matrix.desktop.fileManager;
        "Mod+Z".action = spawn osConfig.matrix.desktop.editor;

        "Mod+Left".action = focus-column-or-monitor-left;
        "Mod+Right".action = focus-column-or-monitor-right;
        "Mod+Down".action = focus-window-or-workspace-down;
        "Mod+Up".action = focus-window-or-workspace-up;

        "Mod+Shift+Left".action = move-column-left-or-to-monitor-left;
        "Mod+Shift+Right".action = move-column-right-or-to-monitor-right;
        "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;

        "Mod+1".action = focus-workspace "1-obsidian";
        "Mod+2".action = focus-workspace "2-discord";
        "Mod+3".action = focus-workspace "3-loa-logs";
        "Mod+4".action = focus-workspace "1-main";

        "Mod+Comma".action = consume-or-expel-window-left;
        "Mod+Period".action = consume-or-expel-window-right;

        "Mod+Shift+S".action.screenshot = { };
        "Mod+S".action = set-dynamic-cast-monitor;
      };
    };
  };
}
