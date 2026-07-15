{
  pkgs,
  self,
  inputs,
  lib,
  ...
}:
with self.lib;
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;

      qemu.options = [
        "-vga none"
        "-device virtio-vga-gl,hostmem=4G"
        "-display gtk,gl=on"
      ];
    };

    # VM-only test password; do not put this in the normal system config.
    users.users.synopia.initialPassword = "test";
  };
  cfg.user = {
    name = "synopia";
    fullName = "Paul Fritsche";
    stateVersion = "26.05";
  };
  cfg.core = {
    isLaptop = false;
    isVM = false;
    networkmanager = enabled;
  };
  cfg.desktop = {
    niri = enabled;
    noctalia = enabled;
    noctalia-greeter = enabled;
    noctalia-theming = {
      gtk = enabled;
      qt = enabled;
    };
  };
  cfg.cli = {
    git = {
      enable = true;
      email = "paul.fritsche@gmail.com";
    };
    fish = enabled;
    starship = enabled;
    neofetch = enabled;
    yazi = enabled;
  };

  cfg.apps = {
    vlc = enabled;
    browsers = {
      brave = enabled;
      chromium = enabled;
      firefox = enabled;
      google-chrome = enabled;
    };
    steam = enabled;
    kitty = enabled;
    dolphin = enabled;
    nautilus = disabled;
    obsidian = enabled;
    zed = enabled;
    discord = enabled;
    whatsapp = enabled;
    pinta = enabled;
    loa-logs = {
      enable = true;
      version = "1.47.2";
      daemonHash = "sha256-AH/o0rRVSuLg9Ex7wDE5f7r17qghnf/lOFdibG4YZ1g=";
      appImageHash = "sha256-43JNlbIFsyvGVlZIPwO36zRTkuqNO2U2ed18PHwjcw8=";
    };
  };

  cfg.services = {
    audio = enabled;
    mate-polkit = enabled;
    flatpak = enabled;
    vmhost = disabled;
  };

  cfg.dev = {
    docker = enabled;
    tools = enabled;

  };
}
