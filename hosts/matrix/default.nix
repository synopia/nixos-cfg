{ inputs, ... }:

{

  flake.nixosConfigurations.matrix = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
    };

    modules = [
      inputs.matugen.nixosModules.default

      ./configuration.nix
    ];
  };
}
