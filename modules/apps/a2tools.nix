{
  pkgs,
  config,
  self,
  lib,
  inputs,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.apps.a2tools;
in
{
  options.cfg.apps.a2tools = {
    enable = mkEnableOption "A2Tools (AION2 DPS Meter)";
  };

  imports = [
    inputs.a2tools.nixosModules.default
    {
      programs.a2tools-dps-meter = {
        enable = true;
        captureUsers = [ "synopia" ];
      };
    }

  ];
  # programs.a2tools-dps-meter = {
  #   enable = true;
  #   captureUser = ["synopia"];
  # };
}
