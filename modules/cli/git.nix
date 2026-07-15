{
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.cli.git;
in
{
  options.cfg.cli.git = {
    enable = mkEnableOption "git";
    name = mkOpt types.str config.cfg.user.name "Git user name";
    email = mkOpt types.str "" "Git user email";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gh ];
    environment.shellAliases = {
      g = "git";
      ga = "git add";
      gaa = "git add -all";
      gb = "git branch";
      gc = "git commit --verbose";
      gcam = "git commit --all --message";
      gd = "git diff";
      gp = "git push";
    };
    programs.git = {
      enable = true;
      config = {
        user = { inherit (cfg) name email; };
        init = {
          defaultBranch = "main";
        };
        push.autoSetupRemote = true;
        pull.rebase = true;
        url = {
          "https://github.com" = {
            insteadof = [
              "gh:"
              "github:"
            ];
          };
        };
      };
    };
  };
}
