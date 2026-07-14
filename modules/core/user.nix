{
  pkgs,
  lib,
  config,
  inputs,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.user;
in
{
  options.cfg.user = {
    name = mkOpt' types.str "Primary username.";
    fullName = mkOpt types.str "" "Full name of the primary user.";
    homeDirectory = mkOpt types.str "/home/${cfg.name}" "Home directory of the primary user.";
    flakesDirectory = mkOpt types.str "/home/${cfg.name}/nixos-cfg" "Flakes Directory of primary user.";

    extraGroups = mkOpt (types.listOf types.str) [
      "wheel"
      "audio"
      "video"
      "input"
    ] "Extra groups for the primary user.";
    stateVersion = mkOpt types.str "26.05" "Nix state version.";

    timeZone = mkOpt types.str "Europe/Berlin" "Timezone";
    defaultLocale = mkOpt types.str "en_US.UTF-8" "Default locale";
    extraLocale = mkOpt types.str "de_DE.UTF-8" "Extra locale";

    smoothScroll = mkBoolOpt true "Smooth scroll";
  };

  imports = [
    inputs.hjem.nixosModules.default
    (mkAliasOptionModule [ "hj" ] [ "hjem" "users" cfg.name ])
  ];

  config = {
    system.stateVersion = cfg.stateVersion;

    hjem = {
      clobberByDefault = false;
      extraModules = [
        inputs.hjem-rum.hjemModules.default
        inputs.noctalia.hjemModules.default

      ];
      users.${cfg.name} = {
        enable = true;
        directory = cfg.homeDirectory;
      };
    };
    users.users.${cfg.name} = {
      isNormalUser = true;
      description = cfg.fullName;
      extraGroups = cfg.extraGroups;
      home = cfg.homeDirectory;
      uid = 1000;
    };
    environment.sessionVariables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
    time.timeZone = mkDefault cfg.timeZone;
    i18n.defaultLocale = mkDefault cfg.defaultLocale;
    i18n.extraLocaleSettings = mkDefault {
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
