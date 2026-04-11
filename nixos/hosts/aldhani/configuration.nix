# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules
    ../../modules/boot.nix
    ../../modules/cli/podman.nix

    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "zfs.zfs_arc_max=8589934592"
    "zfs.zfs_arc_min=4294967296"
    "iommu=pt"
  ];

  networking.hostName = "aldhani"; # Define your hostname.
  networking.hostId = "2ffb69ed";
  networking.firewall.checkReversePath = "loose"; # wireguard needs this 

  environment.systemPackages = with pkgs; [
    mesen
    wireguard-tools 
  ];

  services.fprintd.enable = false;

  services.power-profiles-daemon.enable = true;

  hardware.graphics.enable = true;
  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  services.logind.settings.Login = {
    LidSwitchIgnoreInhibited = "no";
    KillUserProcesses = false;
  };

  systemd.tmpfiles.rules = [
    "z /sys/class/leds/platform::micmute/brightness 0666 - - - -"
  ];
  systemd.user.services.mic-mute-led-sync = {
    description = "Sync microphone mute LED with Pipewire state";
    after = ["pipewire.service" "wireplumber.service"];
    wantedBy = ["default.target"];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "1s";
      ExecStart = pkgs.writeShellScript "mic-mute-led-sync" ''
        readonly LED_PATH="/sys/class/leds/platform::micmute/brightness"
 
        update_led() {
          vol_state=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
          if [[ "$vol_state" == *MUTED* ]]; then
            echo "1" > "$LED_PATH" 2>/dev/null || true
          else
            echo "0" > "$LED_PATH" 2>/dev/null || true
          fi
        }

        # Match current state on startup
        update_led

        # Wait for event changes from Pipewire and update LED accordingly
        ${pkgs.pulseaudio}/bin/pactl subscribe | grep --line-buffered "Event 'change' on source" | while read -r line; do
          update_led
        done
      '';
    };
  };

  users.users.dwaris = {
    isNormalUser = true;
    description = "dwaris";
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
