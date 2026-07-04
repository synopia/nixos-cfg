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
  cfg = config.syncon.cli.neofetch;
in
{
  options.syncon.cli.neofetch = with types; {
    enable = mkBoolOpt false "Whether to enable neofetch.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fastfetch
    ];
  };
}
