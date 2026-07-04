{
  config,
  pkgs,
  lib,
  default,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.system.users;
in
{
  options.syncon.system.users = { };

  config = {
    users.users.${default.username} = {
      createHome = true;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "power"
        "networkmanager"
        "nix"
        "gamemode"
      ];
    };
  };
}
