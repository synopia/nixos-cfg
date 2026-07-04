{
  config,
  pkgs,
  lib,
  default,
  hostName,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.system.hosts.${hostName};
in
{
  options.syncon.system.hosts.${hostName} = {
    wallpaper = mkOpt type.package default.wallpaper "The wallpaper to use for current host.";
    variant = mkOpt (lib.types.enum [
      "light"
      "dark"
      "amoled"
    ]) "dark" "Colorschema variant.";
    type = mkOpt' (lib.types.enum [
      "schema-content"
      "schema-expressive"
      "schema-fidelity"
      "schema-fruit-salad"
      "schema-monochrome"
      "schema-neutral"
      "schema-rainbow"
      "schema-tonal-spot"
    ]) "dark";
  };

  config = {
  };
}
