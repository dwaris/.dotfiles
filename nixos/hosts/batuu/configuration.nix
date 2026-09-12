{pkgs, ...}: let
  username = "dwaris";
in {
  imports = [
    ../../modules/core
    ../../modules/hardware/laptop.nix
    ../../modules/hardware/boot.nix
    ../../modules/hardware/printing.nix
    ../../modules/desktop/gnome.nix

    ../../modules/apps

    ./hardware-configuration.nix
  ];

  networking.hostName = "batuu";
  networking.hostId = "264853fa";

  programs.nh.flake = "/home/${username}/Projects/dotfiles/nixos";

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

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime-legacy1
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  zramSwap.enable = true;
  services.thermald.enable = true;

  system.stateVersion = "26.05";
}
