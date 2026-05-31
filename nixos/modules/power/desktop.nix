{pkgs, ...}: {
  services.tuned = {
    enable = true;
    settings.dynamic_tuning = true;
    ppdSettings.profiles = {
      balanced = "desktop";
      performance = "throughput-performance";
      power-saver = "desktop-powersave";
    };
  };
}
