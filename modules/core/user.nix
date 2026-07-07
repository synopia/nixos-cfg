{ config, lib, ... }:
with lib;
with lib.matrix;
let
  cfg = config.matrix.user;
in
{
  options.matrix.user = {
    name = mkOpt' types.str "Primary username.";
    fullName = mkOpt types.str "" "Full name of the primary user.";
    homeDirectory = mkOpt types.str "/home/${cfg.name}" "Home directory of the primary user.";
    flakesDirectory = mkOpt types.str "/home/${cfg.name}/nixos-cfg" "Flakes Directory of primary user.";

    extraGroups = mkOpt (types.listOf types.str) [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ] "Extra groups for the primary user.";
    homeStateVersion = mkOpt types.str "26.05" "Home Manager state version.";

    timeZone = mkOpt types.str "Europe/Berlin" "Timezone";
    defaultLocale = mkOpt types.str "de_DE.UTF-8" "Default locale";
    extraLocale = mkOpt types.str "de_DE.UTF-8" "Extra locale";
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      description = cfg.fullName;
      extraGroups = cfg.extraGroups;
    };

    home-manager.users.${cfg.name} = {
      home.username = cfg.name;
      home.homeDirectory = cfg.homeDirectory;
      home.stateVersion = cfg.homeStateVersion;
    };

    time.timeZone = cfg.timeZone;

    i18n.defaultLocale = cfg.defaultLocale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.extraLocale;
      LC_IDENTIFICATION = cfg.extraLocale;
      LC_MEASUREMENT = cfg.extraLocale;
      LC_MONETARY = cfg.extraLocale;
      LC_NAME = cfg.extraLocale;
      LC_NUMERIC = cfg.extraLocale;
      LC_PAPER = cfg.extraLocale;
      LC_TELEPHONE = cfg.extraLocale;
      LC_TIME = cfg.extraLocale;
    };
  };
}
