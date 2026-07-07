{ lib }:
args@{ config, ... }:
{
  name,
  description ? name,
  namespace ? [
    "matrix"
  ],
  userOption ? [
    "matrix"
    "user"
    "name"
  ],
  options ? { },
  nixos ? (_: { }),
  home ? (_: { }),
  forceEnable ? false,
}:
let
  featurePath = namespace ++ lib.splitString "." name;
  cfg = lib.getAttrFromPath featurePath config;
  username = lib.getAttrFromPath userOption config;

  callBlock =
    blockArgs: block:
    if lib.isFunction block then block blockArgs else block;

  nixosConfig = callBlock (args // { inherit cfg username; }) nixos;
  homeConfig =
    hmArgs:
    callBlock (args // hmArgs // { inherit cfg username; osConfig = config; }) home;

in
{
  options = lib.setAttrByPath featurePath (
    {
      enable = lib.mkEnableOption description;
    }
    // options
  );

  config = lib.mkIf (cfg.enable || forceEnable) (
    lib.mkMerge [
      nixosConfig
      {
        home-manager.users.${username} = homeConfig;
      }
    ]
  );
}
