{ ... }:
{
  programs.niri.settings = {
    window-rules = [
      {
        matches = [ { app-id = "vesktop"; } ];
        open-on-workspace = "discord";
      }
      {
        matches = [ { app-id = "io.github.tobagin.karere"; } ];
        open-on-workspace = "discord";
      }
      {
        matches = [ { app-id = "obsidian"; } ];
        open-on-workspace = "obsidian";
      }
      {
        matches = [ { app-id = "Loa-logs"; } ];
        open-on-workspace = "loa-log";
      }
    ];
  };
}
