{ lib, ... }:
with lib;
rec {
  mkFeature = import ./mkFeature.nix { inherit lib; };
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  mkOpt' = type: description: mkOption { inherit type description; };

  mkBoolOpt = mkOpt types.bool;

  mkBoolOpt' = mkOpt' types.bool;

  # mkEnable = name: mkBoolOpt false "Enable/disable ${name}.";
  # mkEnable' = name: mkBoolOpt' "Enable/disable ${name}.";

  enabled = {
    enable = true;
  };

  disabled = {
    enable = false;
  };

  getDir =
    dir:
    mapAttrs (file: type: if type == "directory" then getDir "${dir}/${file}" else type) (
      builtins.readDir dir
    );

  files =
    dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  validFiles =
    dir:
    map (file: dir + "/${file}") (
      filter (file: hasSuffix ".nix" file && file != "default.nix" && !lib.hasSuffix "-hm.nix" file) (
        files dir
      )
    );

}
