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
{
  config = {
    services.gnome.gnome-keyring = enabled;
  };
}
