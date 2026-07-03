{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    loupe # images
    clapper # videos
    snapshot # cam
    nautilus # file manager
    baobab # disk
    file-roller # archive
    gnome-system-monitor
    gnome-calculator
    qpwgraph # PipeWire graph viewer
    dgop
    ripgrep
  ];
  # catppuccin = {
  #   enable = true;
  #   autoEnable = true;
  #   flavor = "mocha";
  #   accent = "mauve";
  #   gtk = {
  #     icon = {
  #       enable = true;
  #       flavor = config.catppuccin.flavor;
  #       accent = config.catppuccin.accent;
  #     };

  #   };
  #   kvantum = {
  #     enable = true;
  #     apply = true;
  #   };

  #   qt5ct = {
  #     enable = false;
  #   };
  # };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  home.pointerCursor = {
    name = lib.mkForce "Bibata-Modern-Classic";
    package = lib.mkForce pkgs.bibata-cursors;
    size = lib.mkForce 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}
