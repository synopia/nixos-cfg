{
  lib,
  pkgs,
  inputs,
  config,
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
      icon-theme = "Papirus-Dar";
      drun-display-format = "{name}";
    };
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "@import" = "colors.rasi";
        "*" = {
          background-color = mkLiteral "@surface";
          text-color = mkLiteral "@on-surface";
          font = "Iosevka Nerd Font 16";
        };
        "window" = {
          anchor = mkLiteral "center";
          location = mkLiteral "center";
          padding = mkLiteral "4px";
          width = mkLiteral "20em";
          children = map mkLiteral [
            "horibox"
          ];
          background-color = mkLiteral "@surface";
        };
        "horibox" = {
          orientation = mkLiteral "vertical";
          children = map mkLiteral [
            "prompt"
            "entry"
            "listview"
          ];
        };
        "listview" = {
          layou = mkLiteral "vertical";
          spacing = mkLiteral "5px";
          lines = mkLiteral "10";
        };
        entry = {
          expand = false;
          cursor = mkLiteral "pointer";
          width = mkLiteral "10em";
        };
        element = {
          orientation = mkLiteral "horizontal";
          spacing = mkLiteral "5px";
          children = map mkLiteral [
            "element-text"
            "element-icon"
          ];
        };

        "element-icon" = {
          size = "2.5em";
        };

        "element selected" = {
          background-color = mkLiteral "@primary";
          text-color = mkLiteral "@on-primary";
        };

        "element-text, element-icon" = {
          vertical-align = mkLiteral "0.5";
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };
      };
  };
  # home.file."/.config/rofi/menu.rasi".source =
  # config.lib.file.mkOutOfStoreSymlink "/home/synopia/dev/menu.rasi";

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
