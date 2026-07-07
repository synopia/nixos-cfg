args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "desktop.shell.quickshell";

  options = {
    path = mkOpt types.str "" "Path to quickshell 'shell.qml', is used by qs -p <path>.";
  };

  home =
    { cfg, ... }:
    let
      qsArgs = lib.optionalString (cfg.path != "") "-p ${lib.escapeShellArg cfg.path}";
    in
    {
      xdg.configFile."quickshell" = {
        source = ./quickshell;
        recursive = true;
      };

      programs.quickshell = enabled;
      home.packages = with pkgs; [
        curl
        networkmanager
      ];

      systemd.user.services.quickshell = {
        Unit = {
          Description = "Quickshell desktop shell";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.quickshell}/bin/qs ${qsArgs}";
          Restart = "on-failure";
          RestartSec = 1;
          Environment = [
            "QT_QUICK_CONTROLS_STYLE=Fusion"
          ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  nixos = { cfg, ... }: {
    environment.systemPackages = with pkgs; [
      quickshell
      v4l-utils
    ];
  };
}
