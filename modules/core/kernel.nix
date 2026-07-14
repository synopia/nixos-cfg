{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
{
  options = {
  };
  imports = [
    {
      nixpkgs.overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
        inputs.nur.overlays.default
      ];
    }
  ];
  config = {
    boot = {
      # kernelPackages = pkgs.linuxPackages_xanmod_latest;
      kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
      kernel.sysctl = {
        "kernel.split_lock_mitigate" = 0;
        "kernel.nmi_watchdog" = 0;
        "kernel.sched_bore" = "1";
        "vm.max_map_count" = mkIf (!config.cfg.core.isLaptop && !config.cfg.core.isVM) 2147483642;
      };

    };
  };
}
