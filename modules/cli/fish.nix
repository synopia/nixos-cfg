{
  lib,
  pkgs,
  self,
  config,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.cli.fish;
in
{
  options.cfg.cli.fish.enable = mkEnableOption "fish";
  config = mkIf cfg.enable {
    programs.fish = enabled;
    hj.rum.programs.fish = {
      enable = true;
      aliases = {
        grep = "${getExe pkgs.ripgrep}";
        cat = "${getExe pkgs.bat}";
        ls = "${getExe pkgs.eza} --icons --group-directories-first";
        la = "ls -a";
        ll = "ls -lah";
        lt = "${getExe pkgs.eza} --icons --tree";
        wget = "${getExe pkgs.wget} --hsts-file=$XDG_DATA_HOME/wget-hsts";
        die = "pkill -9";
      };
      config = ''
        set fish_color_autosuggestion 'color3'
      '';
    };
    users.users.${config.cfg.user.name} = {
      shell = pkgs.fish;
    };
    hj = {
      packages = with pkgs; [
        fzf
        ripgrep
        bat
        wget
        eza
      ];
    };
  };
}
