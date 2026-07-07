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
      zsh = disabled;
      #fish=enabled;
    };
    addons = {
      git = {
        enable = true;
        name = "Paul Fritsche";
        email = "paul.fritsche@gmail.com";
      };
      neofetch = enabled;
      starship = enabled;
    };
  };

  matrix.system = {
    nix = enabled;
    audio = enabled;
    flatpak = enabled;
    # gaming = enabled;
  };

  matrix.desktop = {
    terminal = "kitty";

    wm.hyprland = enabled;

    terminals = {
      kitty = enabled;
    };
    shell = {
      quickshell = enabled;
    };
    addons = {
      rofi = enabled;
      dolphin = disabled;
      nautilus = enabled;
      qt = enabled;
    };
  };

  matrix.apps = {
    zed = enabled;
    browsers = {
      firefox = enabled;
    };
  };
}
