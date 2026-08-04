{
  pkgs,
  config,
  self,
  lib,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.apps.telegram;
in
{
  options.cfg.apps.telegram = {
    enable = mkEnableOption "Telegram";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      telegram-desktop
    ];
  };
}
