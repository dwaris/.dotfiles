{pkgs, ...}: let
  autoPowerProfile = pkgs.writeShellScriptBin "auto-power-profile" ''
    # Check sysfs for any online non-battery power supply (AC adapter)
    on_ac=0
    for ps in /sys/class/power_supply/*; do
      if [ -f "$ps/online" ]; then
        type=$(cat "$ps/type" 2>/dev/null || echo "")
        if [ "$type" != "Battery" ] && [ "$(cat "$ps/online")" = "1" ]; then
          on_ac=1
          break
        fi
      fi
    done

    if [ "$on_ac" -eq 1 ]; then
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
    else
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
    fi
  '';
in {
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

  # Systemd service to set power profile based on AC state
  systemd.services.auto-power-profile = {
    description = "Auto Power Profile Switcher based on AC connection";
    after = ["tuned.service" "power-profiles-daemon.service"];
    wants = ["tuned.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${autoPowerProfile}/bin/auto-power-profile";
    };
  };

  # Hook into systemd sleep/resume lifecycle (runs after system wakes up from sleep)
  environment.etc."systemd/system-sleep/auto-power-profile" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      if [ "$1" = "post" ]; then
        ${pkgs.systemd}/bin/systemctl --no-block start auto-power-profile.service
      fi
    '';
  };

  # Trigger service via udev on live power supply events
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ACTION=="change", RUN+="${pkgs.systemd}/bin/systemctl --no-block start auto-power-profile.service"
  '';

  networking.networkmanager.wifi.powersave = true;
}
