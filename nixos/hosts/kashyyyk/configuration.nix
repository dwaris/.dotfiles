{pkgs, ...}: let
  username = "betty";
in {
  imports = [
    ../../modules/core
    ../../modules/hardware/laptop.nix
    ../../modules/hardware/secure-boot.nix
    ../../modules/hardware/printing.nix
    ../../modules/desktop/kde.nix

    ./hardware-configuration.nix
  ];

  networking.hostName = "kashyyyk";
  networking.hostId = "e409d00a";

  boot.kernelParams = [
    "quiet"
  ];
  boot.plymouth.enable = true;

  environment.systemPackages = with pkgs; [
    vlc
    gimp
    firefox
    chromium
    thunderbird
    element-desktop
    libreoffice-qt
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
  ];

  programs.nh.flake = "/home/${username}/Projects/dotfiles/nixos";

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["wheel" "networkmanager"];
  };
  users.users.andrew33 = {
    isNormalUser = true;
    description = "andrew33";
    extraGroups = ["wheel" "networkmanager"];
  };
  users.users.nils06 = {
    isNormalUser = true;
    description = "nils06";
    extraGroups = ["wheel" "networkmanager"];
  };

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime-legacy1
  ];
  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = true;

  zramSwap.enable = true;
  services.thermald.enable = true;

  system.stateVersion = "26.05";
}
