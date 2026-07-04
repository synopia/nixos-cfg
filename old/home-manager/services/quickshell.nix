{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.dev.quickshellService;
  qsArgs = lib.optionalString (cfg.path != "") "-p ${lib.escapeShellArg cfg.path}";

  quickshellDev = pkgs.writeShellApplication {
    name = "quickshell-dev";
    runtimeInputs = [
      pkgs.quickshell
      pkgs.systemd
    ];
    text = ''
      config_path=''${1:-${lib.escapeShellArg cfg.developmentPath}}

      if [[ -z "$config_path" ]]; then
        echo "No development path configured. Pass one as the first argument." >&2
        exit 2
      fi

      if [[ ! -f "$config_path/shell.qml" ]]; then
        echo "No shell.qml found in $config_path" >&2
        exit 2
      fi

      systemctl --user stop quickshell.service
      trap 'systemctl --user start quickshell.service' EXIT

      echo "Running Quickshell from $config_path"
      echo "QML changes reload automatically; press Ctrl+C to restore the managed bar."
      qs -p "$config_path" -vv
    '';
  };
in
{
  options.dev.quickshellService = {
    path = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Installed Quickshell config path used with `qs -p`.";
    };

    developmentPath = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Editable Quickshell source directory used by `quickshell-dev`.";
    };
  };

  config = {
    programs.quickshell.enable = true;
    home.packages = [
      pkgs.curl
      pkgs.networkmanager
      quickshellDev
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
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
