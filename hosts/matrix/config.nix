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
    neofetch = {
      enable = true;
      integrations.fish = true;
    };
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
    telegram = enabled;
    steam = enabled;
    kitty = enabled;
    dolphin = enabled;
    nautilus = disabled;
    obsidian = enabled;
    zed = enabled;
    discord = enabled;
    whatsapp = enabled;
    pinta = enabled;
    pdfarranger = enabled;
    loa-logs = {
      enable = true;
      version = "1.48.5";
      ninevehVersion = "1.48.0";
      daemonHash = "sha256-G0ZQeMRkzkd+quDQdfzszyMTJp5zVzgxXK863bpAK8o";
      appImageHash = "sha256-X20Lq7YFgrB0ZgjC7a+6thpTSFjN7gknTycfs7R6vqU=";
    };
  };

  cfg.services = {
    audio = enabled;
    mate-polkit = enabled;
    flatpak = enabled;
    vmhost = disabled;
    printing = enabled;
    kdeconnect = enabled;
  };

  cfg.dev = {
    docker = enabled;
    tools = enabled;

  };
}
