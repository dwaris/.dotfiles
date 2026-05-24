# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../modules
    ../../modules/secure-boot.nix
    ../../modules/zfs.nix
    ../../modules/desktop/desktop.nix
    # ../../modules/cli/k8s.nix
    ../../modules/gui/gaming

    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "zfs.zfs_arc_max=17179869184"
    "zfs.zfs_arc_min=8589934592"
    "video=DP-1:2560x1440@144"
    "video=DP-2:1920x1080@60"
  ];

  fileSystems."/mnt/tank8tb/media" = {
    device = "tank8tb/media";
    fsType = "zfs";
    options = [ "zfsutil" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=10min" ];
  };

  fileSystems."/mnt/tank8tb/picture" = {
    device = "tank8tb/picture";
    fsType = "zfs";
    options = [ "zfsutil" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=10min" ];
  };

  fileSystems."/mnt/tank8tb/junk" = {
    device = "tank8tb/junk";
    fsType = "zfs";
    options = [ "zfsutil" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=10min" ];
  };

  networking.hostName = "jedha"; # Define your hostname.
  networking.hostId = "d83be86e";

  environment.systemPackages = with pkgs; [
    easyeffects
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  services.pipewire = {
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 128;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 256;
      };
    };
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

  system.stateVersion = "25.05"; # Did you read the comment?
}
