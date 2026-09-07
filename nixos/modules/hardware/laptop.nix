{
  imports = [
    ./network.nix
  ];

  services.logind.settings.Login = {
    LidSwitchIgnoreInhibited = "no";
    KillUserProcesses = false;
  };

  services.tuned = {
    enable = true;
    settings.dynamic_tuning = true;
    ppdSettings.profiles = {
      balanced = "balanced-battery";
      performance = "throughput-performance";
      power-saver = "powersave";
    };
  };

  networking.networkmanager.wifi.powersave = true;
}
