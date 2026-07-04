{
  config,
  pkgs,
  lib,
  default,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.browsers.brave;
in
{
  options.syncon.browsers.brave = {
    enable = mkBoolOpt false "Whether to enable brave browser.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ brave ];
  };
}
