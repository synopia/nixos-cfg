{ lib, ... }:
{

  hjem.users.synopia = {
    imports = [ ./../modules/features/cli/addons/starship-conf.nix ];

    enable = true;
    directory = "/home/synopia";
    user = "synopia";

    rum.programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Paul Fritsche";
          email = "paul.fritsche@gmail.com";
        };
      };
    };
    rum.programs.fish = {
      enable = true;
    };
    rum.programs.starship = {
      enable = true;
      integrations.fish.enable = true;
    };
    rum.programs.kitty = {
      enable = true;
      integrations.fish.enable = true;
    };
    rum.programs.fastfetch.enable = true; # todo integrate
    rum.desktops.niri = {
      enable = true;
      binds = {
        "Mod+T" = {
          spawn = [ "kitty" ];
        };
      };
    };
  };
  # matrix.user = {
  #   name = "synopia";
  #   fullName = "Paul Fritsche";
  #   homeStateVersion = "26.05";
  #   timeZone = "Europe/Berlin";
  #   defaultLocale = "en_US.UTF-8";
  #   extraLocale = "de_DE.UTF-8";
  # };

  # matrix.cli = {
  #   defaultShell = "fish";

  #   shells = {
  #     bash = disabled;
  #     zsh = disabled;
  #     #fish=enabled;
  #   };
  #   addons = {
  #     git = {
  #       enable = true;
  #       name = "Paul Fritsche";
  #       email = "paul.fritsche@gmail.com";
  #     };
  #     neofetch = enabled;
  #     starship = enabled;
  #   };
  # };

  # matrix.dev = {
  #   tools = enabled;
  #   vmhost = enabled;
  #   docker = enabled;
  # };
  # matrix.system = {
  #   net = enabled;
  #   nix = enabled;
  #   audio = enabled;
  #   flatpak = enabled;
  #   gaming = enabled;
  #   printing = enabled;
  # };

  # matrix.desktop = {
  #   terminal = "kitty";

  #   wm.hyprland = enabled;

  #   terminals.kitty = enabled;
  #   shell.quickshell = enabled;

  #   addons = {
  #     hypridle = enabled;
  #     rofi = enabled;
  #     dolphin = disabled;
  #     nautilus = enabled;
  #     qt = enabled;
  #   };
  # };

  # matrix.apps = {
  #   obsidian = enabled;

  #   loa-logs = {
  #     enable = true;
  #     version = "1.47.0";
  #     daemonHash = "sha256-AH/o0rRVSuLg9Ex7wDE5f7r17qghnf/lOFdibG4YZ1g=";
  #     appImageHash = "sha256-kZ5gUee3oCLeHDtKza22MciEjuvjEj0Sq3p5m8Oxc3c=";
  #   };
  #   social = {
  #     discord = enabled;
  #     whatsapp = enabled;
  #   };
  #   zed = enabled;
  #   browsers = {
  #     firefox = enabled;
  #     google-chrome = enabled;
  #   };
  # };
}
