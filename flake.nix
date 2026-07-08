{
  description = "NixOS Config";

  outputs =
    {
      nixpkgs,
      stylix,
      niri,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      mkLib =
        nixpkgs:
        nixpkgs.lib.extend (
          self: super: { matrix = import ./lib { lib = self; }; } // inputs.home-manager.lib
        );

      addHost =
        hostName:
        with inputs;
        let
          lib = mkLib inputs.nixpkgs;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            (./. + "/hosts/${hostName}/")
            {
              nixpkgs.overlays = [
                nix-cachyos-kernel.overlays.pinned
                nur.overlays.default
              ];
            }
            stylix.nixosModules.stylix
            nix-flatpak.nixosModules.nix-flatpak
            hyprland.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs lib;
              };
            }
          ];

          specialArgs = {
            inherit inputs lib;
          };
        };
    in
    {
      nixosConfigurations = {
        # matrix-vm = addHost "matrix-vm";
        matrix = addHost "matrix";
      };
      devShells.x86_64-linux.default =
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        pkgs.mkShell {
          buildInputs = [
            inputs.alejandra.defaultPackage.${system}
            pkgs.shellcheck
            pkgs.shfmt
            pkgs.nil
            pkgs.qt5.qttools
          ];
        };
    };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli-nix.url = "github:sadjow/codex-cli-nix";

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
    };

    nur = {
      url = "github:nix-community/nur";
    };

    niri.url = "github:sodiboo/niri-flake";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
