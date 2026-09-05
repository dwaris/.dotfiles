{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nextcloud-client

    vorta

    localsend
  ];

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [53317];
    allowedUDPPorts = [53317];
  };
}
