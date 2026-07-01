{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.loa-logs;
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
  options.services.loa-logs = {
    enable = lib.mkEnableOption "LOA Logs";
    version = lib.mkOption {
      type = lib.types.str;
      default = "1.46.0";
    };
    daemonHash = lib.mkOption {
      type = lib.types.str;
      default = lib.fakeHash;
      description = "Hash of daemon binary.";
    };
    appImageHash = lib.mkOption {
      type = lib.types.str;
      default = lib.fakeHash;
      description = "Hash of app image file";
    };
    daemonArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "--stop-after-timeout"
        "0"
        "--proxy-without-ipc"
      ];
    };
    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
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
