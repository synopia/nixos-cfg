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

    source =
      mkOpt
        (types.enum [
          "github"
          "local"
        ])
        "github"
        ''
          Which source to install: "github" is the untouched upstream revision
          fetched by the a2tools flake input, "local" builds your working checkout
          at localSource, uncommitted modifications included.
        '';

    localSource = mkOpt types.str "/home/synopia/Projects/1_Privat/A2Tools-DPS-Meter" ''
      Path to the local A2Tools checkout used when source is "local".
    '';
  };

  imports = [
    inputs.a2tools.nixosModules.default
  ];

  config = mkIf cfg.enable {
    programs.a2tools-dps-meter = {
      enable = true;
      captureUsers = [ "synopia" ];
      source = cfg.source;
      localSource = cfg.localSource;
    };

    services.input-remapper.enable = true;
  };
}
