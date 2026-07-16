{
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.cli.yazi;
  xxh128sum = pkgs.writeShellScriptBin "xxh128sum" ''
    exec ${pkgs.xxhash}/bin/xxhsum -H2 "$@"
  '';
in
{
  options.cfg.cli.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (yazi.override {
        _7zz = _7zz-rar;
      })
      xxhash
      xxh128sum
      fuse-archive
    ];
    hj.rum.programs.yazi = {
      enable = true;
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "<Right>";
            run = "plugin fuse-archive -- mount";
          }
          {
            on = "<Left>";
            run = "plugin fuse-archive -- leave";
          }

        ];
      };
    };
  };
}
