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

  networking.firewall = {
    enable = true;
    checkReversePath = "loose"; # wireguard needs this
  };
  networking.nftables.enable = true;

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
