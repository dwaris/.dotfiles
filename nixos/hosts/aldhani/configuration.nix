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
    ../../modules/secure-boot.nix
    ../../modules/zfs.nix
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

  environment.systemPackages = with pkgs; [
    mesen
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

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="*micmute", RUN+="${pkgs.coreutils}/bin/chmod 666 /sys/class/leds/%k/brightness"
  '';

  systemd.user.services.mic-mute-led-sync = {
    description = "Mic Mute LED Sync";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "pipewire.service" "wireplumber.service" ];
    
    # Crucial: Give the script the exact path to the tools it needs
    path = with pkgs; [ wireplumber pulseaudio gnugrep coreutils ];

    script = ''
      readonly LED_PATH="/sys/class/leds/platform::micmute/brightness"

      update_led() {
        if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
          echo "1" > "$LED_PATH" 2>/dev/null || true
        else
          echo "0" > "$LED_PATH" 2>/dev/null || true
        fi
      }

      # 1. Match current state on startup
      update_led

      # 2. Wait for event changes from Pipewire and update LED instantly
      pactl subscribe | grep --line-buffered "Event 'change' on source" | while read -r _; do
        update_led
      done
    '';
  };

  users.groups.dwaris = {
    gid = 1000;
  };
  users.users.dwaris = {
    isNormalUser = true;
    uid = 1000;
    group = "dwaris";
    description = "dwaris";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/dwaris/Projects/.dotfiles/nixos";
  };
  nix.gc.automatic = mkDefault false;

  fileSystems."/home/dwaris/Documents" = {
    device = "zpool/shared/dwaris/documents";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/dwaris/Downloads" = {
    device = "zpool/shared/dwaris/downloads";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/dwaris/Music" = {
    device = "zpool/shared/dwaris/music";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/dwaris/Pictures" = {
    device = "zpool/shared/dwaris/pictures";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/dwaris/Projects" = {
    device = "zpool/shared/dwaris/projects";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/dwaris/Videos" = {
    device = "zpool/shared/dwaris/videos";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
