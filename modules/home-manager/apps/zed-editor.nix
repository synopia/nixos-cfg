{
  config,
  pkgs,
  lib,
  ...
}:
{

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
    ];
    userSettings = {
      lsp = {
        lua-language-server = {
          settings = {
            Lua = {
              workspace.library = [
                "${config.wayland.windowManager.hyprland.package}/share/hypr/stubs"
              ];
            };
          };
        };
        qmljs = {
          binary = {
            path = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
            arguments = [
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
                  expr = "(builtins.getFlake \"/home/synopia/nixos-config\").nixosConfigurations.matrix.options";
                };
                home_manager = {
                  expr = "(builtins.getFlake \"/home/synopia/nixos-config\").nixosConfigurations.matrix.options.home-manager.users.type.getSubOptions []";
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
}
