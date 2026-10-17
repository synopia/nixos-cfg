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
      version = "1.51.3";
      ninevehVersion = "1.51.1";
      daemonHash = "sha256-5ZYz8vd5Is3SXg8X/7KCQ4Z+EndxE8bjJ4kn+rT4/GQ=";
      appImageHash = "sha256-piTnFPEobUeG0JT7OGSmzkwY2iy+mMtbOhbNonMX8pI=";
    };
    a2tools = enabled // {
      # "github" = untouched upstream revision, "local" = the working checkout
      # at cfg.apps.a2tools.localSource (uncommitted modifications included).
      source = "local";
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
    mudfish = {
      enable = true;
      autoStart = true;
    };
  };

  cfg.dev = {
    docker = enabled;
    tools = enabled;

  };
}
