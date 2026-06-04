{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    syncthingtray
  ];

  services.syncthing = {
    enable = false;
    openDefaultPorts = false;
    user = "dwaris";
    group = "users";
    dataDir = "/home/dwaris"; # default location for new folders
    configDir = "/home/dwaris/.config/syncthing";
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
