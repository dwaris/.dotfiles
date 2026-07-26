{pkgs, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [
      "--accept-routes"
      "--ssh"
    ];
  };

  # Force tailscaled to use nftables instead of iptables (Critical for clean nftables-only systems)
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
}
