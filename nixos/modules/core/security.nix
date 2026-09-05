{...}: {
  networking.firewall.enable = true;
  networking.nftables.enable = true;

  services.openssh = {
    enable = true;
    allowSFTP = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
    extraConfig = "TrustedUserCAKeys ${../../certs/ca_key.pub}";
  };
}
