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
    llm = enabled;
    loa-logs = {
      enable = true;
      version = "1.50.2";
      ninevehVersion = "1.50.0";
      daemonHash = "sha256-WaHgTYS1AxxzHYYPyuhIJYAB5oNh0jBwP7y1goJYvsA=";
      appImageHash = "sha256-Lw2HGJIJkC6iJUYG+rjuG8fAM3/jTvpDZOOLZ+9ItZg=";
    };
  };

  cfg.services = {
    audio = enabled;
    mate-polkit = enabled;
    flatpak = enabled;
    vmhost = disabled;
    printing = enabled;
    kdeconnect = enabled;
    jellyfin = enabled;
  };

  cfg.dev = {
    docker = enabled;
    tools = enabled;

  };
}
