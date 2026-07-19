{
  lib,
  pkgs,
  self,
  config,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.cli.neofetch;
in
{
  options.cfg.cli.neofetch = {
    enable = mkEnableOption "Neofetch (fastfetch)";
    integrations = {
      fish = mkEnableOption "neofetch integration with fish";
    };
  };

  config = mkIf cfg.enable {
    hj.rum.programs = {
      fish.earlyConfigFiles = mkIf cfg.integrations.fish {
        fast-fetch = "command -q fastfetch; and fastfetch";
        set-path = "fish_add_path ~/.local/bin";
      };
    };

    hj.packages = [
      pkgs.fastfetch
    ];
  };
}
