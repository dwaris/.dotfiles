# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/profiles/laptop.nix
    ../../modules/secure-boot.nix
    ../../modules/zfs.nix

    ../../modules/networking/wireguard.nix
    ../../modules/networking/tailscale/client.nix

    ../../modules/desktop/hyprland.nix

    ../../modules/cli/podman.nix

    ../../modules/gui/gaming

    ./hardware-configuration.nix
  ];

  boot.kernelParams = ["iommu=pt"];

  networking.hostName = "aldhani"; # Define your hostname.
  networking.hostId = "2ffb69ed";

  environment.systemPackages = [];

  services.fprintd.enable = false;

  hardware.graphics.enable = true;
  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="*micmute", RUN+="${pkgs.coreutils}/bin/chmod 666 /sys/class/leds/%k/brightness"
  '';

  systemd.user.services.mic-mute-led-sync = {
    description = "Mic Mute LED Sync";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["pipewire.service" "wireplumber.service"];

    # Crucial: Give the script the exact path to the tools it needs
    path = with pkgs; [wireplumber pulseaudio gnugrep coreutils];

    script = ''
      readonly LED_PATH="/sys/class/leds/platform::micmute/brightness"

      update_led() {
        if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
          echo "1" > "$LED_PATH" 2>/dev/null || true
        else
          echo "0" > "$LED_PATH" 2>/dev/null || true
        fi
      }

      # Wait for WirePlumber to successfully read the default audio source (Exit Code 0)
      while wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>&1 | grep -q "Translate ID error: '-1'"; do
        sleep 0.5
      done

      # 1. Match current state on startup
      update_led

      # 2. Wait for event changes from Pipewire and update LED instantly
      pactl subscribe | grep --line-buffered "Event 'change' on source" | while read -r _; do
        update_led
      done
    '';
  };

  users.groups.${username} = {
    gid = 1000;
  };
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    group = username;
    description = username;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
  };

  fileSystems."/home/${username}/Documents" = {
    device = "zpool/shared/${username}/documents";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Downloads" = {
    device = "zpool/shared/${username}/downloads";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Music" = {
    device = "zpool/shared/${username}/music";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Pictures" = {
    device = "zpool/shared/${username}/pictures";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Projects" = {
    device = "zpool/shared/${username}/projects";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Videos" = {
    device = "zpool/shared/${username}/videos";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
