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
  environment.systemPackages = with pkgs; [
    btop
    fd
    jq
    tree
    git
    dgop
  ];
}
