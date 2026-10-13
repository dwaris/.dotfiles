{pkgs, ...}: {
  imports = [
    ../../modules/core
    ../../modules/users/dwaris.nix
    ../../modules/hardware/laptop.nix
    ../../modules/hardware/secure-boot.nix
    ../../modules/hardware/zfs.nix
    ../../modules/hardware/zfs-home.nix
    ../../modules/hardware/printing.nix
    ../../modules/hardware/vpn/wireguard.nix
    ../../modules/hardware/vpn/tailscale-client.nix

    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/oo7.nix

    ../../modules/apps

    ./hardware-configuration.nix
  ];

  networking.hostName = "aldhani";
  networking.hostId = "2ffb69ed";

  boot.kernelParams = [
    "iommu=pt"
  ];

  boot.extraModprobeConfig = ''
    options zfs zfs_arc_max=8589934592
  '';

  environment.systemPackages = with pkgs; [
    # llama-cpp-vulkan
  ];

  systemd.services.alsa-init = {
    description = "Initialize ALSA sound cards and UCM";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      SuccessExitStatus = [0 99];
      ExecStart = "${pkgs.alsa-utils}/bin/alsactl init";
    };
  };

  hardware.graphics.enable = true;
  hardware.amdgpu.opencl.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  services.fprintd.enable = true;

  security.pam.services = {
    sudo.fprintAuth = false;
    login.fprintAuth = false;
    su.fprintAuth = false;
    hyprlock.fprintAuth = false;
  };

  system.stateVersion = "23.11";
}
