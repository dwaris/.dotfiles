{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    syncthingtray
  ];

  services.syncthing = {
    enable = false;
    openDefaultPorts = false;
    user = username;
    group = "users";
    dataDir = "/home/${username}"; # default location for new folders
    configDir = "/home/${username}/.config/syncthing";
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
