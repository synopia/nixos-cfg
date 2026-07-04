{
  inputs,
  config,
  lib,
  pkgs,
  options,
  default,
  hostName,
  ...
}:
with lib;
let
  cfg = config.syncon.home;
  wallpaper = config.syncon.system.hosts.${hostName}.wallpaper or default.wallpaper;
in
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  options.syncon.home = with types; {
    file = mkOption {
      type = types.attrs;
      description = ''
        A set of files to be managed by home-manager's <option>home.file</option>.
      '';
    };
    configFile = mkOption {
      type = types.attrs;
      description = ''
        A set of files to be managed by home-manager's <option>xdg.configFile</option>.
      '';
    };
    dataFile = mkOption {
      type = types.attrs;
      description = ''
        A set of files to be managed by home-manager's <option>xdg.dataFile</option>.
      '';
    };
    extraOptions = mkOption {
      type = types.attrs;
      description = ''
        Options to pass directly to home-manager.
      '';
    };
    programs = mkOption {
      type = types.attrs;
      description = ''
        Options to pass directly to home-manager.
      '';
    };
  };

  config = {
    syncon.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.syncon.home.file;
      programs = mkAliasDefinitions options.syncon.home.programs;
      xdg.enable = true;
      xdg.dataFile = mkAliasDefinitions options.syncon.home.dataFile;
      xdg.configFile = mkAliasDefinitions options.syncon.home.configFile;
    };
    home-manager = {
      useGlobalPkgs = true;
      users.${default.username} =
        { config, ... }:
        mkMerge [
          (mkAliasDefinitions options.syncon.home.extraOptions)
          {
            xdg.configFile = {
              "rofi/config.rasi".source =
                config.lib.file.mkOutOfStoreSymlink "${default.configFolder}/rofi/config.rasi";

              "quickshell".source = config.lib.file.mkOutOfStoreSymlink "${default.configFolder}/quickshell";
            };

          }
        ];
    };
  };
}
