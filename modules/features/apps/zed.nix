args@{
  lib,
  pkgs,
  config,
  ...
}:
let
  quickshellVfs = "";
in
with lib;
with lib.matrix;
mkFeature args {
  name = "apps.zed";

  options = {
  };
  home = { cfg, ... }: {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "rust"
        "qml"
        "lua"
      ];
      extraPackages = with pkgs; [
        nil
        nixd
        nixfmt
        kdePackages.qtdeclarative
        quickshell
        luau-lsp
      ];

      mutableUserSettings = true;
      userSettings = {
        ssh_connections = [
          {
            host = "192.168.122.233";
            projects = [
              {
                paths = [ "~/nixos-cfg" ];
              }
            ];
          }
        ];
        lsp = {
          lua-language-server = {
            settings = {
              Lua = {
                workspace.library = [
                  "${pkgs.hyprland}/share/hypr/stubs"
                ];
              };
            };
          };
          qmljs = {
            binary = {
              path = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
              arguments = [
                "--build-dir"
                quickshellVfs
                "-I"
                quickshellVfs
                "-I"
                "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
                "-I"
                "${pkgs.quickshell}/lib/qt-6/qml"
                "--no-cmake-calls"
              ];
            };
          };
          nil = {
            binary = {
              path = lib.getExe pkgs.nil;
            };
          };
          nixd = {
            binary = {
              path = lib.getExe pkgs.nixd;
            };
            settings = {
              nixd = {
                options = {
                  nixos = {
                    expr = "(builtins.getFlake \"${config.matrix.user.flakesDirectory}\").nixosConfigurations.matrix.options";
                  };
                  home_manager = {
                    expr = "(builtins.getFlake \"${config.matrix.user.flakesDirectory}\").nixosConfigurations.matrix.options.home-manager.users.type.getSubOptions []";
                  };
                };
              };
            };
          };
        };
        languages = {
          "QML" = {
            language_servers = [ "qmljs" ];
          };
          "Nix" = {
            language_servers = [ "nixd" ];
            formatter = {
              external = {
                command = lib.getExe pkgs.nixfmt;
              };
            };
            format_on_save = "on";
          };
        };
        hour_format = "hour24";
      };
    };
  };
}
