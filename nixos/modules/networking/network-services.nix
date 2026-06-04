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
