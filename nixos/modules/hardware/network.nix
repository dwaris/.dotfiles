{pkgs, ...}: {
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [networkmanager-openvpn];
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
