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

  ];
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    gtk = {
      icon = {
        enable = true;
        flavor = config.catppuccin.flavor;
        accent = config.catppuccin.accent;
      };
    };
    kvantum = {
      enable = true;
      apply = true;
    };

    qt5ct = {
      enable = false;
    };
  };

  gtk = {
    enable = true;

  };

  home.pointerCursor = {
    name = lib.mkForce "Bibata-Modern-Classic";
    package = lib.mkForce pkgs.bibata-cursors;
    size = lib.mkForce 24;
    gtk.enable = true;
    x11.enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";

  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "kde";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}
