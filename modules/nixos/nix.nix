{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Allow tools downloaded by applications (for example Zed extensions) to
  # run dynamically linked executables built for conventional Linux systems.
  programs.nix-ld.enable = true;
}
