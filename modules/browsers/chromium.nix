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
  cfg = config.syncon.browsers.chromium;
in
{
  options.syncon.browsers.chromium = {
    enable = mkBoolOpt false "Whether to enable chromium browser.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ chromium ];
  };
}
