{
  pkgs,
  lib,
  ...
}: let
  username = "dwaris";
in {
  imports = [
    ../../modules/core
    ../../modules/users/dwaris.nix
    ../../modules/hardware/desktop.nix
    ../../modules/hardware/secure-boot.nix
    ../../modules/hardware/zfs.nix
    ../../modules/hardware/zfs-home.nix
    ../../modules/hardware/printing.nix
    ../../modules/hardware/vpn/tailscale-server.nix

    ../../modules/desktop/kde.nix
    ../../modules/desktop/oo7.nix

    ../../modules/apps
    ../../modules/apps/gaming.nix

    ./hardware-configuration.nix
  ];

  networking.hostName = "jedha";
  networking.hostId = "d83be86e";

  boot.extraModprobeConfig = ''
    options zfs zfs_arc_max=17179869184
  '';

  environment.systemPackages = with pkgs; [
    easyeffects

    llama-cpp-rocm
    pi-coding-agent
  ];

  hardware.keyboard.qmk.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.opencl.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [
      "--performance"
    ];
  };

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

  systemd.services.udp-gro-forwarding = {
    description = "Tailscale UDP GRO forwarding for eno1";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${lib.getExe pkgs.ethtool} -K eno1 rx-udp-gro-forwarding on rx-gro-list off";
    };
  };

  fileSystems."/home/${username}/Games" = {
    device = "zpool/shared/games";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  fileSystems."/mnt/tank8tb/media" = {
    device = "tank8tb/media";
    fsType = "zfs";
    options = ["zfsutil" "nofail" "noauto" "x-systemd.automount" "x-gvfs-hide"];
  };
  fileSystems."/mnt/tank8tb/picture" = {
    device = "tank8tb/picture";
    fsType = "zfs";
    options = ["zfsutil" "nofail" "noauto" "x-systemd.automount" "x-gvfs-hide"];
  };
  fileSystems."/mnt/tank8tb/junk" = {
    device = "tank8tb/junk";
    fsType = "zfs";
    options = ["zfsutil" "nofail" "noauto" "x-systemd.automount" "x-gvfs-hide"];
  };

  system.stateVersion = "25.05";
}
