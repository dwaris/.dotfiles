{...}: {
  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "stable-ssid";
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
