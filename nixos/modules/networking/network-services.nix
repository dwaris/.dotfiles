{pkgs, ...}: {
  services.openssh = {
    enable = false;
    allowSFTP = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["dwaris"];
    };
  };
  services.openssh.extraConfig = "TrustedUserCAKeys ${../../.certs/ca_key.pub}";

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

  networking.firewall = {
    enable = true;
    checkReversePath = "loose"; # wireguard needs this
    trustedInterfaces = [ "tailscale0" ];
  };
  networking.nftables.enable = true;

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
