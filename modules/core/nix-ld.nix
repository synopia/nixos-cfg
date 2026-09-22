{ pkgs, self, ... }:
with self.lib;
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
          at-spi2-atk
          at-spi2-core
          atk
          cairo
          cups
          dbus
          expat
          fontconfig
          freetype
          glib
          gtk3
          libdrm
          libgbm
          libxkbcommon
          nspr
          nss
          pango
          systemd
          stdenv.cc.cc
          zlib

          libX11
          libXcomposite
          libXcursor
          libXdamage
          libXext
          libXfixes
          libXi
          libXrandr
          libXrender
          libXtst
          libxcb
    ];
  };
}
