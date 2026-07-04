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
  cfg = config.syncon.cli.git;
in
{
  options.syncon.cli.git = with types; {
    enable = mkBoolOpt false "Whether to enable git.";
    email = mkOption {
      type = str;
      default = "";
      description = ''
        The email address to use.
      '';
    };
    name = mkOption {
      type = str;
      default = "";
      description = ''
        The name to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    syncon.home.extraOptions = {
      programs.git = {
        enable = true;
        settings = {
          user.email = config.syncon.cli.git.email;
          user.name = config.syncon.cli.git.name;
          alias = {
            s = "status";
            a = "add";
            c = "commit";
          };
        };
      };
      programs.gh = {
        enable = true;
        gitCredentialHelper = {
          enable = true;
        };
      };
    };
  };
}
