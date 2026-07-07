{ pkgs, ... }:
{

  boot = {
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
    kernel.sysctl = {
      "kernel.split_lock_mitigate" = 0;
      "kernel.nmi_watchdog" = 0;
      "kernel.sched_bore" = "1";
    };

    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "ntsync"
      "preempt=full"
    ];
  };
}
