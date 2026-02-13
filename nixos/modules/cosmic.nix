{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wl-clipboard

    nomacs
    kdePackages.okular
  ];

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  services.system76-scheduler.enable = true;
}
