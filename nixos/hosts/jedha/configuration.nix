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

  networking.hostName = "jedha";
  networking.hostId = "d83be86e";

  boot.kernelParams = [
    "amdgpu.runpm=0" # broken BACO sleep
    "amdgpu.aspm=0" # dcn32 compbuf timeout
  ];

  environment.systemPackages = with pkgs; [
    easyeffects
    ethtool
    llama-cpp-rocm
  ];

  programs.nh.flake = "/home/${username}/Projects/dotfiles/nixos";

  users.groups.${username} = {
    gid = 1000;
  };
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    group = username;
    description = username;
    extraGroups = ["wheel" "networkmanager" "uinput" "input"];
    shell = pkgs.zsh;
  };

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
    extraGroups = ["wheel" "networkmanager" "uinput" "input"];
    shell = pkgs.zsh;
  };

  systemd.services."zfs-sync-tank8tb".enable = false;

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

  systemd.services."zfs-sync-tank8tb".enable = false;
  fileSystems."/mnt/tank8tb/media" = {
    device = "tank8tb/media";
    fsType = "zfs";
    options = ["zfsutil" "nofail" "x-systemd.automount" "x-gvfs-hide"];
  };
  fileSystems."/mnt/tank8tb/picture" = {
    device = "tank8tb/picture";
    fsType = "zfs";
    options = ["zfsutil" "nofail" "x-systemd.automount" "x-gvfs-hide"];
  };
  fileSystems."/mnt/tank8tb/junk" = {
    device = "tank8tb/junk";
    fsType = "zfs";
    options = ["zfsutil" "nofail" "x-systemd.automount" "x-gvfs-hide"];
  };

  system.stateVersion = "25.05";
}
