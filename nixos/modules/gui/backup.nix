{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vorta
    syncthingtray
  ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "dwaris";
    group = "users";
    dataDir = "/home/dwaris";  # default location for new folders
    configDir = "/home/dwaris/.config/syncthing";
  };
}
