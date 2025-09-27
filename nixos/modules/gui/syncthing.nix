{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    syncthingtray
  ];

  services.syncthing = {
    enable = false;
    openDefaultPorts = true;
    user = "dwaris";
    group = "users";
    dataDir = "/home/dwaris";  # default location for new folders
    configDir = "/home/dwaris/.config/syncthing";
  };
}