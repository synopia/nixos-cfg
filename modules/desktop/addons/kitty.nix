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
  cfg = config.syncon.desktop.addons.kitty;
in
{
  options.syncon.desktop.addons.kitty = with types; {
    enable = mkBoolOpt false "Whether to enable kitty.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kitty
      jq
    ];
  };
}
