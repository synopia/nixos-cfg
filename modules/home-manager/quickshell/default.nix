{ lib, pkgs, ... }:
{
  xdg.configFile."quickshell/shell.qml".source = ./shell.qml;

  xdg.configFile."quickshell/components" = {
    source = lib.cleanSource ./components;
    recursive = true;
  };

  xdg.configFile."quickshell/services" = {
    source = lib.cleanSource ./services;
    recursive = true;
  };

  home.activation.quickshellNotificationState = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -d -m 700 \
      "$HOME/.local/state/quickshell/notifications"
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/touch \
      "$HOME/.local/state/quickshell/notifications/history.json" \
      "$HOME/.local/state/quickshell/notifications/received.json"
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/chmod 600 \
      "$HOME/.local/state/quickshell/notifications/history.json" \
      "$HOME/.local/state/quickshell/notifications/received.json"
  '';
}
