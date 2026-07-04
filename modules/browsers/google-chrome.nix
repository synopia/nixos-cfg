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
  cfg = config.syncon.browsers.google-chrome;
in
{
  options.syncon.browsers.google-chrome = {
    enable = mkBoolOpt false "Whether to enable google-chrome browser.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ google-chrome ];
  };
}
