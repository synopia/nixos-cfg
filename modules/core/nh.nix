{
  pkgs,
  lib,
  config,
  inputs,
  self,
  ...
}:
with lib;
with self.lib;
let
in
{
  config = {
    environment.systemPackages = with pkgs; [
      nh
    ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/synopia/nixos-cfg";
    };
  };
}
