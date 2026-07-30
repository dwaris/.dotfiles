{username, ...}: {
  services.openssh = {
    enable = true;
    allowSFTP = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [username];
    };
  };
  services.openssh.extraConfig = "TrustedUserCAKeys ${../../.certs/ca_key.pub}";
}
