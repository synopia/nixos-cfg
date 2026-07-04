{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/home-manager
  ];

  dev.quickshellService.path = "/home/synopia/nixos-config/modules/home-manager/quickshell";
  dev.quickshellService.developmentPath = "/home/synopia/nixos-config/modules/home-manager/quickshell";
  xdg.configFile."hypr/config/user.lua".source = ./hyprland.lua;
  xdg.configFile."openvpn/bishop.localdomain.ovpn".source = ./openvpn/bishop.localdomain.ovpn;

  home.activation.installOpenVpnCredentials = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -d -m 700 "$HOME/.config/openvpn"

    for file in \
      ca-cert.pem \
      client-paul.fritsche-cert.pem \
      client-paul.fritsche-key.pem
    do
      source="$HOME/OpenVPN/$file"
      target="$HOME/.config/openvpn/$file"

      if [ -f "$source" ]; then
        $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 600 "$source" "$target"
      fi
    done
  '';

  home.username = "synopia";
  home.homeDirectory = "/home/synopia";
  home.stateVersion = "26.05";

  # catppuccin = {
  # enable = true;
  # autoEnable = true;
  # flavor = "mocha";
  # };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Paul Fritsche";
      email = "paul.fritsche@gmail.com";
    };
  };

  programs.rofi = {
    enable = true;
    modes = [ "drun" ];
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus-Dark";
      drun-display-format = "{name}";
    };
  };
  home.file."/.config/rofi/menu.rasi".text = ''
        @import "colors.rasi"

        /**
         * ROFI Color theme
         * User: Qball
         * Copyright: Dave Davenport
         */

        * {
            background-color: @surface;
            text-color: @on-surface;
            font: "Iosevka Nerd Font 16";
        }

        window {
            anchor: north;
            location: north;
            width: 100%;
            padding: 4px;
            children: [ horibox ];
            background-color: @surface;
        }

    /*    horibox {
            orientation: horizontal;
            children: [ prompt, entry, listview ];
        }

        listview {
            layout: horizontal;
            spacing: 5px;
            lines: 100;
        }
    */
        entry {
            expand: false;
            width: 10em;
        }

        element {
            orientation: horizontal;
            spacing: 5px;
            children: [ element-text, element-icon ];

        }

        element selected {
            background-color: @primary-fixed-dim;
            text-color: @on-primary;
        }

        element-text, element-icon {
          background-color: inherit;
          text-color: inherit;
        }

  '';
  home.packages = with pkgs; [
    htop
    btop
    fd
    jq
    quickshell
    kdePackages.dolphin
    google-chrome
    firefox
    networkmanagerapplet
    inputs.codex-cli-nix.packages.${pkgs.system}.default
    fastfetch
    vesktop
    karere
    obsidian
    magnetic-catppuccin-gtk
    sqlite
    xxd
    gzip
  ];
  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.google-chrome.enable = true;

  programs.kitty.enable = true;
  programs.zed-editor.enable = true;

  programs.fish = {
    interactiveShellInit = ''
      command -q fastfetch; and fastfetch
    '';
  };
}
