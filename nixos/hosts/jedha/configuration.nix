# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  ...
}: let
  username = "dwaris";
in {
  imports = [
    ../../modules/core
    ../../modules/hardware/desktop.nix
    ../../modules/hardware/secure-boot.nix
    ../../modules/hardware/zfs.nix
    ../../modules/hardware/printing.nix
    ../../modules/hardware/vpn/tailscale-server.nix

    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/oo7.nix

    ../../modules/apps
    ../../modules/apps/gaming/extra.nix

    ./hardware-configuration.nix
  ];

  fileSystems."/mnt/tank8tb/media" = {
    device = "tank8tb/media";
    fsType = "zfs";
    options = ["zfsutil" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=10min" "x-gvfs-hide"];
  };

  fileSystems."/mnt/tank8tb/picture" = {
    device = "tank8tb/picture";
    fsType = "zfs";
    options = ["zfsutil" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=10min" "x-gvfs-hide"];
  };

  fileSystems."/mnt/tank8tb/junk" = {
    device = "tank8tb/junk";
    fsType = "zfs";
    options = ["zfsutil" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=10min" "x-gvfs-hide"];
  };

  networking.hostName = "jedha"; # Define your hostname.
  networking.hostId = "d83be86e";

  boot.kernelParams = [
    "mem_sleep_default=s2idle"
  ];

  boot.initrd.clevis = {
    enable = true;
    devices."zpool".secretFile = "/etc/clevis/zpool.jwe";
  };

  systemd.services.tpm-pcr15-invalidation = {
    description = "Invalidate PCR 15 to lock disk keys away from userspace";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tpm2-tools}/bin/tpm2_pcrextend 15:sha256=0000000000000000000000000000000000000000000000000000000000000000";
    };
  };

  environment.systemPackages = with pkgs; [
    clevis
    tpm2-tools
    easyeffects
    ethtool
    llama-cpp-rocm
  ];

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

  hardware.keyboard.qmk.enable = true;
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

  programs.nh.flake = "/home/${username}/Projects/dotfiles/nixos";

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [
      "--performance"
    ];
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

  fileSystems."/home/${username}/Nextcloud" = {
    device = "zpool/shared/nextcloud";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  fileSystems."/home/${username}/Games" = {
    device = "zpool/shared/games";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
