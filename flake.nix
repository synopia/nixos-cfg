{
  description = "NixOS Config";

  outputs =
    { nixpkgs, ... }@inputs:
    let
      default = {
        stateVersion = "26.05";

        flakePath = "/home/${default.username}/nixos-config";
        templateFolder = "${default.flakePath}/dots/templates";
        configFolder = "${default.flakePath}/dots/config";
        localFolder = "${default.flakePath}/dots/local";
        desktopEntryFolder = "${default.flakePath}/dots/desktop-entries";
        scriptFolder = "${default.flakePath}/dots/scripts";

        system = "x86_64-linux";
        username = "synopia";

        wallpaper =
          let
            url = "https://wallpapercave.com/download/future-wallpaper-wp2975125";
            sha256 = "0cb612220733b7f4cf8cb96039e6726f68f057d097ad1cd36ee8a71982a4fadc";
            ext = nixpkgs.lib.last (nixpkgs.lib.splitString "." url);
          in
          builtins.fetchurl {
            name = "wallpaper-${sha256}.${ext}";
            inherit url sha256;
          };
      };

      mkLib =
        nixpkgs:
        nixpkgs.lib.extend (
          self: super: { syncon = import ./lib { lib = self; }; } // inputs.home-manager.lib
        );

      addHost =
        hostName:
        with inputs;
        nixpkgs.lib.nixosSystem {
          system = default.system;
          modules = [
            ./modules
            (./. + "/hosts/${hostName}/")
            {
              nixpkgs.overlays = [
                # nix-cachyos-kernel.overlays.pinned
                nur.overlays.default
              ];

              environment.systemPackages = [
                matugen.packages.${default.system}.default
              ];
            }
            inputs.matugen.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
          ];

          specialArgs = {
            lib = mkLib inputs.nixpkgs;
            inherit inputs hostName default;
          };
        };
    in
    {
      nixosConfigurations = {
        matrix = addHost "matrix";
      };
      devShell.x86_64-linux =
        with import nixpkgs {
          stdenv.hostPlatform.system = "x86_64-linux";
        };
        mkShell {
          buildInputs = [
            inputs.alejandra.defaultPackage.${stdenv.hostPlatform.system}
            shellcheck
            shfmt
            nil
            qt5.qttools
            (pkgs.writeShellScriptBin "wallfetch" ''
              if [ ! -f flake.nix ]; then echo "This script is supposed to be ran from flake root." && exit 1; fi;

              path="hosts/$(hostname)/wallpaper.nix"
              sha256=$(curl $1 | sha256sum | cut -d ' ' -f 1 )
              if [ ! -f $path ]; then
                  touch $path
              fi

              echo $sha256

              echo "{
                  url = \"$1\";
                  sha256 = \"$sha256\";
              }" > $path
            '')
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

    matugen = {
      url = "github:/InioX/Matugen";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland"; # v0.55.4
      # inputs.nixpkgs.follows = "nixpkgs";
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
    # nixos-manager = {
    # url = "github:icefirex/nixos-manager";
    # inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nix-ld = {
    #   url = "github:Mic92/nix-ld";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # flake-parts.lib.mkFlake { inherit inputs; } {
  #   systems = [ "x86_64-linux" ];

  #   imports = [
  #     ./hosts/matrix
  #   ];

  #   perSystem = { pkgs, ... }: {
  #     formatter = pkgs.nixfmt;
  #   };

  # };
  #
  #
}
