{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.desktop.noctalia;
in
{
  options.cfg.desktop.noctalia = {
    enable = mkEnableOption "Noctalia";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      python3

    ];
    programs.noctalia = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      systemd = enabled;
      recommendedServices = enabled;
    };

    hj.programs.noctalia = {
      enable = true;
      systemd = enabled;
      settings = {
        theme = {
          builtin = "Ayu";
          mode = "dark";
          source = "builtin";
        };
      };
    };
  };
}
