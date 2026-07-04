{
  config,
  pkgs,
  lib,
  inputs,
  default,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.desktop.addons.quickshell;
  # yet-another-monochrome-icons = pkgs.stdenv.mkDerivation {
  #   pname = "yet-another-monochrome-icon-set";
  #   version = "latest";
  #   src = pkgs.fetchzip {
  #     url = "https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set/get/main.zip";
  #     sha256 = "sha256-KzAWx+ls4Y0WzaFIdCjtarkr68/uE9jyeRreLyPcziw=";
  #   };

  #   installPhase = ''
  #     mkdir -p $out/share/icons/Yet-Another-Monochrome
  #     cp -r * $out/share/icons/Yet-Another-Monochrome/
  #   '';
  # };
in
{
  options.syncon.desktop.addons.quickshell = with types; {
    enable = mkBoolOpt false "Whether to enable quickshell.";
  };

  config = mkIf cfg.enable {
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      quickshell
      # yet-another-monochrome-icons
    ];
  };
}
