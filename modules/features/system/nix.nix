args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
mkFeature args {
  name = "system.nix";

  options = {
  };

  home = {
    home.packages = with pkgs; [
      btop
      fd
      jq
      tree
      git
      dgop
      ripgrep
    ];
  };
  nixos = {
    services = {
      dbus.implementation = "broker";
      systembus-notify = enabled;
    };
    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      optimise.automatic = true;
      settings = {
        auto-optimise-store = true;
        max-jobs = 8;
        cores = 8;
        eval-cache = true;
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://nixpkgs-wayland.cachix.org"
          "https://hyprland.cachix.org"
          "https://cache.garnix.io"
          "https://attic.xuyh0120.win/lantian"
          "https://ezkea.cachix.org"
        ];
      };
    };
    nixpkgs.config.allowUnfree = true;
    programs.nix-ld.enable = true;
    # services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    services.openssh = {
      enable = true;
      openFirewall = true;
    };
  };
}
