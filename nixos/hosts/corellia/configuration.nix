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

    ../../modules/cli
    ../../modules/cli/podman.nix

    ../../modules/gui
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "zfs.zfs_arc_max=5368709120" # 5 GiB (4GB + 1GiB per 1TB of storage)
  ];

  networking.hostName = "corellia"; # Define your hostname.
  networking.hostId = "2ffb69ed";

  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
    extraUpFlags = [
      "--accept-routes"
      "--ssh"
    ];
  };

  environment.systemPackages = with pkgs; [
    mesen
    wireguard-tools 
  ];

  services.fprintd.enable = false;

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

  users.users.dwaris = {
    isNormalUser = true;
    description = "dwaris";
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
