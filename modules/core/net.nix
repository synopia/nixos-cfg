{ hostName, ... }:
{
  config = {
    networking = {
      inherit hostName;
    };
  };
}
