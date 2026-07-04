{ lib, ... }:
with lib;
rec {
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  mkOpt' = type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;

  mkBoolOpt' = mkOpt' types.bool;

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

  fetchImage =
    url: sha256:
    let
      ext = lib.last (lib.splitString "." url);
    in
    builtins.fetchurl {
      name = "wallpaper-${sha256}.${ext}";
      inherit url sha256;
    };
}
