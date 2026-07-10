{ ... }:
{
  programs.niri = {
    settings = {
      spawn-at-startup = [
        # {
        #   command = [
        #     "systemctl"
        #     "--user"
        #     "start"
        #     "hyprpolkitagent"
        #   ];
        # }
        # { command = [ "arrpc" ]; }
        { command = [ "xwayland-satellite" ]; }
        { command = [ "noctalia" ]; }
        { command = [ "vesktop" ]; }
        { command = [ "karere" ]; }
        { command = [ "obsidian" ]; }
        { command = [ "loa-logs" ]; }
        {
          command = [
            "steam"
            "-silent"
          ];
        }
        {
          command = [
            "jetbrains-toolbox"
            "-s"
          ];
        }
      ];
    };
  };
}
