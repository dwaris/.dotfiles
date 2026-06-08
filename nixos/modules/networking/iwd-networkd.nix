{pkgs, ...}: {
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks = {
      "20-ethernet" = {
        matchConfig = {
          Name = "en*";
        };
        linkConfig = {
          RequiredForOnline = "routable";
        };
        networkConfig = {
          DHCP = "yes";
        };
        dhcpV4Config = {
          RouteMetric = 100;
        };
        ipv6AcceptRAConfig = {
          RouteMetric = 100;
        };
      };

      "25-wireless" = {
        matchConfig = {
          Name = "wl*";
        };
        linkConfig = {
          RequiredForOnline = "routable";
        };
        networkConfig = {
          DHCP = "yes";
        };
        dhcpV4Config = {
          RouteMetric = 600;
        };
        ipv6AcceptRAConfig = {
          RouteMetric = 600;
        };
      };
    };
  };
  systemd.network.wait-online.enable = false;

  networking.wireless.iwd.enable = true;

  services.resolved = {
    enable = true;
    settings.Resolve.DNSStubListenerExtra = [ "[::1]:53" ];
  };

  environment.systemPackages = with pkgs; [
    impala
  ];
}
