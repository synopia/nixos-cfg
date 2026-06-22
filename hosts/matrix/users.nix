{ pkgs, ... }:
{
  users.users.synopia = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "lp"
      "scanner"
    ];
    packages = with pkgs; [
      tree
      git
      kitty
      neovim
      rofi
      thunar
      swaybg
      vis
    ];
  };
}
