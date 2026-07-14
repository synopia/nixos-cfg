{
  description = "NixOS Config";

  outputs =
    {
      self,
      nixpkgs,
      niri,
      noctalia-greeter,
      hjem,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      supportedSystems = [ "x86_64-linux" ];
      forAllSystems =
        apply: lib.genAttrs supportedSystems (system: apply nixpkgs.legacyPackages.${system});

      # addHost =
      #   hostName:
      #   with inputs;
      #   let
      #     lib = mkLib inputs.nixpkgs;
      #   in
      #   nixpkgs.lib.nixosSystem {
      #     inherit system;

      #     modules = [
      #       (./. + "/hosts/${hostName}/")
      #       {
      #         nixpkgs.overlays = [
      #           nix-cachyos-kernel.overlays.pinned
      #           nur.overlays.default
      #         ];
      #       }
      #       nix-flatpak.nixosModules.nix-flatpak
      #       hyprland.nixosModules.default
      #       noctalia-greeter.nixosModules.default
      #       hjem.nixosModules.default
      #     ];

      #     specialArgs = {
      #       inherit inputs;
      #     };
      #   };
    in
    {
      lib = import ./lib { inherit lib inputs; };

      nixosConfigurations = import ./hosts {
        inherit self inputs lib;
      };
      nixosModules.default = self.lib.validFiles ./modules;

      # nixosConfigurations = {
      # matrix-vm = addHost "matrix-vm";
      # matrix = addHost "matrix";
      # };
      # devShells.x86_64-linux.default =
      #   let
      #     pkgs = import nixpkgs {
      #       inherit system;
      #     };
      #   in
      #   pkgs.mkShell {
      #     buildInputs = [
      #       inputs.alejandra.defaultPackage.${system}
      #       pkgs.shellcheck
      #       pkgs.shfmt
      #       pkgs.nil
      #       pkgs.qt5.qttools
      #     ];
      #   };
    };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hjem.follows = "hjem";
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

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qtengine = {
      url = "github:kossLAN/qtengine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
