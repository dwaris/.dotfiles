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

  networking.firewall = {
    enable = true;
    checkReversePath = "loose"; # wireguard needs this
  };
  networking.nftables.enable = true;

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
