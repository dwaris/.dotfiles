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

    ../../modules/cli
    ../../modules/cli/k8s.nix

    ../../modules/gui
    ../../modules/gui/gaming

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "zfs.zfs_arc_max=6442450944" # 6 GiB (4GB + 1GiB per 1TB of storage)
    "mem_sleep_default=s2idle"
    "video=DP-1:2560x1440@144"
    "video=DP-2:1920x1080@60"
  ];
  boot.supportedFilesystems = [
    "ntfs"
  ];

  fileSystems."/mnt/HDD_8TB" = {
    device = "/dev/disk/by-uuid/AA94E0A794E0776B";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "nofail"
      "x-systemd.device-timeout=30"
    ];
  };

  networking.hostName = "jedha"; # Define your hostname.
  networking.hostId = "d83be86e";

  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--advertise-exit-node"
      "--advertise-routes=192.168.178.0/24"
      "--ssh"
    ];
  };
  systemd.services."udp-gro-forwarding" = {
    description = "UDP Gro Forwarding Service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "udp-gro-forwarding" ''
        set -eux
        ${lib.getExe pkgs.ethtool} -K eno1 rx-udp-gro-forwarding on rx-gro-list off;
      ''}";
    };
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
  };

  environment.systemPackages = with pkgs; [
    easyeffects

    ethtool
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

  users.users.dwaris = {
    isNormalUser = true;
    description = "dwaris";
    extraGroups = ["wheel" "networkmanager"];
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
