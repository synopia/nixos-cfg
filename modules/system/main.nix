{
  config,
  pkgs,
  lib,
  default,
  inputs,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.system;

  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    set -euo pipefail

    sudo nixos-rebuild switch \
        --flake ${default.flakePath} \
        --no-reexec \
        --log-format internal-json \
        |& nom --json
  '';
in
{
  options.syncon.system = {
    diffScript = mkBoolOpt true "Enables showing what packages changes between generations.";
    defaultShell = mkOpt (types.enum [
      pkgs.bash
      pkgs.zsh
      pkgs.fish
    ]) pkgs.bash "Which shell to set the default to.";
  };

  config = {
    users.users.${default.username} = {
      shell = cfg.defaultShell;
    };

    system.stateVersion = default.stateVersion;

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${default.flakePath}";
    };

    environment.variables.NH_OS_FLAKE = "${default.flakePath}";

    services.gvfs.enable = true;
    services.gnome.gnome-keyring.enable = true;
    environment = {
      systemPackages = with pkgs; [
        choose
        nix-output-monitor
        rebuild

        vim
        wget
        git
        btop
        resources
        usbutils
        yazi
        dgop

        inputs.matugen.packages.${stdenv.hostPlatform.system}.default
      ];

      sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_DESKTOP_DIR = "$HOME";
        XDG_DOCUMENTS_DIR = "$HOME/docs";
      };
    };
    syncon.home.extraOptions.xdg.userDirs = {
      createDirectories = true;
      enable = true;
      setSessionVariables = true;
      documents = "$HOME/docs";
      download = "$HOME/down";
      pictures = "$HOME/pics";
      videos = "$HOME/vids";
      desktop = "$HOME";
      music = "$HOME";
      templates = "$HOME";
      publicShare = "$HOME";
    };
  };
}
