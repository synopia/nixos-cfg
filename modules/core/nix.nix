{ pkgs, self, ... }:
with self.lib;
{
  config = {
    nix = {
      package = pkgs.nixVersions.latest;
      channel = disabled;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        max-jobs = 8;
        cores = 8;
        auto-optimise-store = true;
        warn-dirty = false;
        allow-import-from-derivation = false;
        use-xdg-base-directories = true;
        allowed-users = [ "@wheel" ];
        trusted-users = [ "@wheel" ];
        extra-substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos-cuda.org"
          "https://hyprland.cachix.org"

          "https://cache.nixos.org"
          "https://nixpkgs-wayland.cachix.org"
          "https://attic.xuyh0120.win/lantian"
          "https://ezkea.cachix.org"
          "https://noctalia.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="

          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };
    nixpkgs.overlays = [
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (
            python-final: python-prev: {
              nanoemoji = python-prev.nanoemoji.overridePythonAttrs (oldAttrs: {
                # GitHub's generated archive for this tag changed upstream.
                src = final.fetchFromGitHub {
                  owner = "googlefonts";
                  repo = "nanoemoji";
                  rev = "refs/tags/v${oldAttrs.version}";
                  hash = "sha256-FysyKC01XBnRiur5RR9fcsTxQqE8x0JJHSoe3q6JtKc=";
                };
              });
            }
          )
        ];
      })
    ];
    nixpkgs.config = {
      allowUnfree = true;
    };
    documentation.nixos = disabled;
    systemd.services = {
      nix-gc = {
        unitConfig.ConditionACPower = true;
      };
      nh-clean = {
        unitConfig.ConditionACPower = true;
      };
    };
  };
}
