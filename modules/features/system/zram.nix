{ config, ... }:
{
  zramSwap = {
    enable = true;
    memoryPercent = 150;
    algorithm = "lz4";
  };

  boot = {
    kernelParams = [ "zswap.enabled=0" ];
    kernel.sysctl = {
      "vm.swappiness" = 150;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };
}
