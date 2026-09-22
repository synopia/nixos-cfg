{
  pkgs,
  config,
  self,
  lib,
  inputs,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.apps.llm;
in
{
  options.cfg.apps.llm = {
    enable = mkEnableOption "LLM Support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.prism-llama.packages.${pkgs.stdenv.hostPlatform.system}.rocm
    ];
  };
}
