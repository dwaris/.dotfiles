{ pkgs, ... }: {
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks = {
      "20-ethernet" = {
        matchConfig = {
          Name = "e*";
        };
        networkConfig = {
          DHCP = "yes";
        };
      };

      "25-wireless" = {
        matchConfig = {
          Name = "w*";
        };
        networkConfig = {
          DHCP = "yes";
        };
      };
    };
  };
  systemd.network.wait-online.enable = true;

  networking.wireless.iwd.enable = true;

  services.resolved.enable = true;

  environment.systemPackages = with pkgs; [
    impala
  ];
}
