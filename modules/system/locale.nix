{
  config,
  pkgs,
  lib,
  default,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.system.locale;
in
{
  options.syncon.system.locale = {
    timeZone = mkOpt types.str none "The time zone used for system.";
  };

  config = {
    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };
}
