args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
let

in
mkFeature args {
  name = "apps.loa-logs";

  options = {
    version = mkOpt types.str "1.47.0" "LoaLogs Version";
    daemonHash = mkOpt types.str fakeHash "Hash of daemon binary";
    appImageHash = mkOpt types.str fakeHash "Hash of app image file";
    daemonArgs = mkOpt (types.listOf types.str) [
      "--stop-after-timeout"
      "0"
      "--proxy-without-ipc"
    ] "Daemon arguments";
    environment = mkOpt (types.attrsOf types.str) { } "Env";
  };

  nixos =
    { cfg, ... }:
    let
      daemonPackage = pkgs.stdenvNoCC.mkDerivation {
        pname = "loa-logs-nineveh";
        inherit (cfg) version;

        src = pkgs.fetchurl {
          url = "https://github.com/snoww/loa-logs/releases/download/v${cfg.version}/nineveh";
          hash = cfg.daemonHash;
        };

        dontUnpack = true;
        installPhase = ''
          install -Dm755 "$src" "$out/bin/nineveh"
        '';
      };

      appImageSrc = pkgs.fetchurl {
        url = "https://github.com/snoww/loa-logs/releases/download/v${cfg.version}/LOA.Logs_${cfg.version}_amd64.AppImage";
        hash = cfg.appImageHash;
      };

      appImagePackage = pkgs.appimageTools.wrapType2 {
        pname = "loa-logs";
        inherit (cfg) version;
        src = appImageSrc;
        extraPkgs = pkgs: [ ];
      };

      appLauncher = pkgs.writeShellScriptBin "loa-logs" ''
          export GDK_BACKEND=x11
          #export WEBKIT_DISABLE_DMABUF_RENDERER=1 GDK_BACKEND=wayland
        export LD_PRELOAD="${pkgs.wayland}/lib/libwayland-client.so"
        exec ${appImagePackage}/bin/loa-logs "$@"
      '';
      desktopItem = pkgs.makeDesktopItem {
        name = "loa-logs";
        desktopName = "LOA Logs";
        exec = "${appLauncher}/bin/loa-logs";
        categories = [ "Utility" ];
      };

      guiPackage = pkgs.symlinkJoin {
        name = "loa-logs-gui";
        paths = [
          appLauncher
          desktopItem
        ];
      };
    in
    {
      environment.systemPackages = [
        daemonPackage
        guiPackage
      ];
      systemd.services.loa-logs-nineveh = {
        description = "LOA Logs nineveh";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        environment = cfg.environment;

        serviceConfig = {
          ExecStart = ''
            ${daemonPackage}/bin/nineveh ${lib.escapeShellArgs cfg.daemonArgs}
          '';
          Restart = "on-failure";
          RestartSec = "5s";

          WorkingDirectory = "/var/lib/loa-logs";
          StateDirectory = "loa-logs";
        };
      };
    };
}
