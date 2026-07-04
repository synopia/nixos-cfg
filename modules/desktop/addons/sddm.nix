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
  cfg = config.syncon.desktop.addons.sddm;
in
{
  options.syncon.desktop.addons.sddm = with types; {
    enable = mkBoolOpt false "Whether to enable sddm.";
  };

  config = mkIf cfg.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
          compositor = "kwin";
        };
        autoNumlock = true;
      };
    };
  };
}
