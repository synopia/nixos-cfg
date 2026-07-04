{
  config,
  pkgs,
  lib,
  inputs,
  default,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.cli.fish;
in
{
  options.syncon.cli.fish = with types; {
    enable = mkBoolOpt false "Whether to enable fish.";
  };

  config = mkIf (cfg.enable || config.syncon.system.defaultShell == pkgs.fish) {
    programs.fish = {
      enable = true;
    };
  };
}
