{

  self,
  inputs,
  lib,
}:
with lib;
let
  hostNames = attrNames (filterAttrs (_: v: v == "directory") (readDir ./.));

  mkSystem =
    hostName:
    nixosSystem {
      specialArgs = {
        inherit self inputs hostName;
        mudfishLegacy = inputs.nixpkgs-mudfish;
      };
      modules = flatten [
        self.nixosModules.default
        ./${hostName}/config.nix
        ./${hostName}/hardware-configuration.nix
        # (self.lib.validFiles ./${hostName})
      ];
    };
in
lib.genAttrs hostNames mkSystem
