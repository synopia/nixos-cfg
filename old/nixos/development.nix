{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixos-manager.nixosModules.default ];

  programs.nixos-manager = {
    enable = true;
    package = inputs.nixos-manager.packages.${pkgs.system}.default;
  };

  environment.variables = {
    FLAKE_DIR = "/home/synopia/nixos-config";
  };
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };

    # Periodically remove unused layers while retaining recent build cache.
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--filter=until=168h" ];
    };
  };

}
