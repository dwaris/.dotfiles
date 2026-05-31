{pkgs, ...}: {
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

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance"
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"
  '';
}
