{
  config,
  pkgs,
  lib,
  ...
}: {
  services.logind.settings.Login = {
    LidSwitchIgnoreInhibited = "no";
    KillUserProcesses = false;
  };

  services.tuned = {
    enable = true;
    settings.dynamic_tuning = true;
    ppdSettings.profiles = {
      balanced = lib.mkDefault "balanced-battery";
      performance = lib.mkDefault "throughput-performance";
      power-saver = lib.mkDefault "powersave";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance"
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"
  '';
}
