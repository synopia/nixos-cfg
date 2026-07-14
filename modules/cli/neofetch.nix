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
      fish.enable = mkEnableOption "neofetch integration with fish";
    };
  };

  config = mkIf cfg.enable {
    hj.rum.programs = {
      fish.config = mkIf cfg.integrations.fish.enable (mkAfter "command -q fastfetch; and fastfetch");
    };

    hj.packages = [
      pkgs.fastfetch
    ];
  };
}
