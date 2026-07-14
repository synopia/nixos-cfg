{
  pkgs,
  config,
  self,
  lib,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.apps.zed;
  quickshellVfs = "";
in
{
  options.cfg.apps.zed = {
    enable = mkEnableOption "Zed Editor";
  };
  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
    hj.packages = with pkgs; [
      nil
      nixd
      nixfmt
      kdePackages.qtdeclarative
      quickshell
      luau-lsp
    ];
    hj.rum.programs.zed = {
      enable = true;
      # extensions = [
      #   "nix"
      #   "toml"
      #   "rust"
      #   "qml"
      #   "lua"
      # ];

      # mutableUserSettings = true;
      # userSettings = {
      #   ssh_connections = [
      #     {
      #       host = "192.168.122.233";
      #       projects = [
      #         {
      #           paths = [ "~/nixos-cfg" ];
      #         }
      #       ];
      #     }
      #   ];
      #   lsp = {
      #     lua-language-server = {
      #       settings = {
      #         Lua = {
      #           workspace.library = [
      #             "${pkgs.hyprland}/share/hypr/stubs"
      #           ];
      #         };
      #       };
      #     };
      #     qmljs = {
      #       binary = {
      #         path = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
      #         arguments = [
      #           "--build-dir"
      #           quickshellVfs
      #           "-I"
      #           quickshellVfs
      #           "-I"
      #           "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
      #           "-I"
      #           "${pkgs.quickshell}/lib/qt-6/qml"
      #           "--no-cmake-calls"
      #         ];
      #       };
      #     };
      #     nil = {
      #       binary = {
      #         path = lib.getExe pkgs.nil;
      #       };
      #     };

      #   };
      #   languages = {
      #     "QML" = {
      #       language_servers = [ "qmljs" ];
      #     };
      #     "Nix" = {
      #       language_servers = [ "nixd" ];
      #       formatter = {
      #         external = {
      #           command = lib.getExe pkgs.nixfmt;
      #         };
      #       };
      #       format_on_save = "on";
      #     };
      #   };
      #   hour_format = "hour24";
      # };
    };
  };
}
