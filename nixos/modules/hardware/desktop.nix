{
  imports = [
    ./network.nix
  ];

  services.tuned = {
    enable = true;
    settings.dynamic_tuning = true;
    profiles = {
      desktop-custom = {
        main.include = "desktop";
        scsi_host.alpm = "max_performance";
      };
      desktop-powersave-custom = {
        main.include = "desktop-powersave";
        scsi_host.alpm = "max_performance";
      };
    };
    ppdSettings.profiles = {
      balanced = "desktop-custom";
      performance = "throughput-performance";
      power-saver = "desktop-powersave-custom";
    };
  };
}
