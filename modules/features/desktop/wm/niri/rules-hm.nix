{ ... }:
{
  programs.niri.settings = {
    layer-rules = [
      {
        matches = [ { namespace = "notification"; } ];
        block-out-from = "screencast";
      }
    ];
    window-rules = [
      {
        matches = [ { app-id = "vesktop"; } ];
        open-on-workspace = "2-discord";
      }
      {
        matches = [ { app-id = "io.github.tobagin.karere"; } ];
        open-on-workspace = "2-discord";
      }
      {
        matches = [ { app-id = "obsidian"; } ];
        open-on-workspace = "1-obsidian";
      }
      {
        matches = [ { app-id = "Loa-logs"; } ];
        open-on-workspace = "3-loa-logs";
      }
    ];
  };
}
