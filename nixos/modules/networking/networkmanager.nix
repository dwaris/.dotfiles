{pkgs, ...}: {
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [networkmanager-openvpn];
    wifi = {
      backend = "iwd";
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
