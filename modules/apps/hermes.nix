{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib;
with self.lib;
let
  cfg = config.cfg.apps.hermes;
in
{
  options.cfg.apps.hermes = {
    enable = mkEnableOption "Hermes agent";
  };

#   imports = [
#     inputs.home-manager.nixosModules.home-manager
#     {
#       home-manager.useGlobalPkgs = true;
#       home-manager.useUserPackages = true;
#
#       home-manager.users.synopia = {
#         imports = [
#           inputs.hermes-agent.homeManagerModules.default
#         ];
#
#         programs.hermes-agent = {
#           enable = true;
#           desktop.enable = true;
#         };
#
#         # services.hermes-agent = {
#         #   enable = true;
#         #   gateway.enable = true;
#         #   backend.mode = "dashboard";
#         #   backend.port = 9119;
#         # };
#         home.stateVersion = "25.11";
#       };
#     }
#   ];
}
