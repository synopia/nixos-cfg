{
  config,
  inputs,
  lib,
  ...
}:
let
  flavor = config.catppuccin.flavor;
  accent = config.catppuccin.accent;

  paletteJson = builtins.fromJSON (builtins.readFile "${inputs.catppuccin-palette}/palette.json");
  flavorData = paletteJson.${flavor};

  colors = lib.mapAttrs (_name: value: value.hex) flavorData.colors;

  qmlColorProps = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: hex: ''readonly property color ${name}: "${hex}"'') colors
  );
in
{
  xdg.configFile."quickshell/theme/Theme.qml".text = ''
    pragma Singleton
    import QtQuick

    QtObject {
      readonly property string flavor: "${flavor}"
      readonly property string accentName: "${accent}"

      ${qmlColorProps}

      readonly property color accent: "${colors.${accent}}"
    }
  '';
  # programs.quickshell = {
  #   enable = true;
  #   activeConfig = "bar";

  #   configs.bar = pkgs.runCommand "quickshell-bar-config" { } ''
  #     mkdir -p $out
  #     cp ${./quickshell/shell.qml} $out/shell.qml
  #     cp ${themeQml} $out/Theme.qml
  #   '';
  # };
}
