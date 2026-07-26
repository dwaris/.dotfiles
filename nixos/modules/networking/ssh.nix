{pkgs, ...}: {
  services.openssh = {
    enable = true;
    allowSFTP = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["dwaris"];
    };
  };
  services.openssh.extraConfig = "TrustedUserCAKeys ${../../.certs/ca_key.pub}";
}
