{pkgs, ...}: let
  username = "dwaris";
in {
  imports = [
    ../../modules/core
    ./hardware-configuration.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = username;

  boot.tmp.cleanOnBoot = true;

  networking.hostName = "wsl";
  networking.hostId = "533cdfa7";

  programs.nh.flake = "/home/${username}/Projects/dotfiles/nixos";

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";
}
