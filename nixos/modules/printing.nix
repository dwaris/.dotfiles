{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      brlaser
      gutenprint
    ];
  };

  # Enable Avahi for network printer auto-discovery (mDNS)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_MFC-J5720DW";
        location = "Arbeitszimmer";
        description = "Brother MFC-J5720DW series";
        deviceUri = "ipp://192.168.178.20:631/ipp/print";
        model = "everywhere";
      }
      {
        name = "Brother_HL-4150CDN";
        location = "Arbeitszimmer";
        description = "Brother HL-4150CDN series";
        deviceUri = "ipp://192.168.178.21:631/ipp/port1";
        model = "drv:///sample.drv/generic.ppd";
      }
    ];
    ensureDefaultPrinter = "Brother_HL-4150CDN";
  };
}
