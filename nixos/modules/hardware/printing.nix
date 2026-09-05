{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
    ];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_MFC-J5720DW";
        location = "Arbeitszimmer";
        description = "Brother MFC-J5720DW series";
        deviceUri = "ipp://192.168.178.20:631/ipp/print";
        model = "drv:///cupsfilters.drv/pwgrast.ppd";
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
