args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.terminals.kitty";
  description = "Kitty terminal";

  options = {
    fontSize = mkOpt types.int 12 "Kitty font size";
  };

  home = { cfg, ... }: {
    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
        window_margin_width = 21.75;
        cursor_shape = "beam";
        cursor_trail = 1;
        shell = config.matrix.cli.defaultShell;
      };
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+shift+c" = "copy_to_clipboard";

        "ctrl+f" =
          "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";

        "page_up" = "scroll_page_up";
        "page_down" = "scroll_page_down";

      };
    };

    home.packages = [
      pkgs.kitty
    ];
  };
}
