{ pkgs, self, ... }:
with self.lib;
{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    python3
    uv

    rocmPackages.rocminfo
    clinfo
  ];
  users.users.synopia.extraGroups = [
    "video"
    "render"
  ];
}
