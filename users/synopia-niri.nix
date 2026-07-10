{ lib, ... }:
with lib.matrix;
{
  matrix.user = {
    name = "synopia";
    fullName = "Paul Fritsche";
    homeStateVersion = "26.05";
    timeZone = "Europe/Berlin";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "de_DE.UTF-8";
  };

  matrix.cli = {
    defaultShell = "fish";

    shells = {
      bash = enabled;
      zsh = enabled;
      fish = enabled;
    };
    addons = {
      nnn = enabled;
      git = {
        enable = true;
        name = "Paul Fritsche";
        email = "paul.fritsche@gmail.com";
      };
      neofetch = enabled;
      starship = enabled;
    };
  };

  matrix.dev = {
    tools = enabled;
    vmhost = enabled;
    docker = enabled;
  };
  matrix.system = {
    net = enabled;
    nix = enabled;
    audio = enabled;
    flatpak = enabled;
    gaming = enabled;
    printing = enabled;
  };

  matrix.desktop = {
    enable = true;
    terminal = "kitty";
    fileManager = "dolphin";

    wm.niri = enabled;

    terminals.kitty = enabled;
    # shell.quickshell = enabled;

    addons = {
      hypridle = enabled;
      rofi = enabled;
      dolphin = enabled;
      nautilus = enabled;
      qt = enabled;
    };
  };

  matrix.apps = {
    obsidian = enabled;

    loa-logs = {
      enable = true;
      version = "1.47.1";
      daemonHash = "sha256-AH/o0rRVSuLg9Ex7wDE5f7r17qghnf/lOFdibG4YZ1g=";
      appImageHash = "sha256-4bY7gxom6F0OZenzilqNMf6hDoReM4b+EyTiblJgeHU=";
    };
    social = {
      discord = enabled;
      whatsapp = enabled;
    };
    zed = enabled;
    browsers = {
      firefox = enabled;
      google-chrome = enabled;
    };
  };
}
