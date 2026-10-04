{pkgs, ...}: let
  user = "dwaris";
in {
  environment.systemPackages = with pkgs; [
    syncthingtray
  ];

  services.syncthing = {
    enable = true;
    user = user;
    group = "users";
    dataDir = "/home/${user}";
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [22000];
    allowedUDPPorts = [22000 21027];
  };
}
