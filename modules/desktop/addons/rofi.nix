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
  cfg = config.syncon.desktop.addons.rofi;
in
{
  options.syncon.desktop.addons.rofi = with types; {
    enable = mkBoolOpt false "Whether to enable rofi.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rofi
    ];
  };
}
