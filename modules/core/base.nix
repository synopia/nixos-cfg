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
  programs.partition-manager.enable = true;

  environment.systemPackages = with pkgs; [
    btop-rocm
    fd
    jq
    tree
    git
    dgop
    parted
    ffmpeg
  ];
}
