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
  cfg = config.syncon.cli.starship;
in
{
  options.syncon.cli.starship = with types; {
    enable = mkBoolOpt false "Whether to enable starship.";
  };

  config = mkIf cfg.enable {
    syncon.home.programs.starship = {
      enable = true;
      enableBashIntegration = true;
    };
    programs.bash.promptInit = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
  };
}
