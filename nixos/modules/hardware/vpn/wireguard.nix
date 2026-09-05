{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  networking.firewall = {
    checkReversePath = "loose"; # wireguard needs this
  };
}
