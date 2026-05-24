{ lib, ... }:
{
  services.tuned = {
    enable = true;
    settings.dynamic_tuning = true;
    ppdSettings.profiles = {
      balanced = lib.mkDefault "desktop";
      performance = lib.mkDefault "throughput-performance";
      power-saver = lib.mkDefault "desktop-powersave";
    };
  };
}