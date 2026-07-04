{ inputs, ... }:

{

  flake.nixosConfigurations.matrix = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
    };

    modules = [
      # inputs.stylix.nixosModules.stylix

      ./configuration.nix
    ];
  };
}
