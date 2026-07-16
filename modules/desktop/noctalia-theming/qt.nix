{
  pkgs,
  config,
  self,
  inputs,
  lib,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.desktop.noctalia-theming.qt;
in
{
  options.cfg.desktop.noctalia-theming.qt = {
    enable = mkEnableOption "Noctalia Theming (QT)";
  };

  imports = [ inputs.qtengine.nixosModules.default ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # libsForQt5.qt5ct
      # kdePackages.qt6ct
      # libsForQt5.qtstyleplugin-kvantum
      # kdePackages.qtstyleplugin-kvantum
      # kdePackages.breeze
      # kdePackages.breeze.qt5
      kdePackages.breeze-icons

      # kdePackages.breeze
      # kdePackages.breeze-icons
      # (symlinkJoin {
      #   inherit (qt6Packages.qt6ct)
      #     name
      #     pname
      #     version
      #     meta
      #     ;
      #   paths = [ qt6Packages.qt6ct ];
      #   postBuild = ''
      #     unlink $out/share/applications/qt6ct.desktop
      #   '';
      # })
    ];
    environment.sessionVariables = {
      # QT_QPA_PLATFORMTHEME = "qt6ct";
      # QT_STYLE_OVERRIDE = "Fusion";
    };
    programs.qtengine = {
      enable = true;
      config = {
        theme = {
          colorScheme = "/home/synopia/.local/share/color-schemes/noctalia.colors";
          iconTheme = "breeze-dark";
          style = "breeze";
          font = {
            family = "Inter";
            size = 11;
            weight = -1;
          };
          fontFixed = {
            family = "JetBrains Mono";
            size = 11;
            weight = -1;
          };
        };
        font = {
          family = "Noto Serif";
          size = 11;
          weight = -1;
        };
        fontFixed = {
          family = "JetBrains Mono";
          size = 12;
          weight = -1;
        };
      };
    };

  };
}
