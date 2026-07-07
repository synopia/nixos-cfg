args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "cli.addons.git";

  options = {
    email = mkOpt types.str "" "The email address to use.";
    name = mkOpt types.str "" "The name to use.";
  };

  home = { cfg, ... }: {
    programs.git = {
      enable = true;
      settings = {
        user.email = cfg.email;
        user.name = cfg.name;
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
}
