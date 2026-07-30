# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/profiles/headless.nix

    ./hardware-configuration.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = username;

  boot.tmp.cleanOnBoot = true;

  networking.hostName = "wsl"; # Define your hostname.
  networking.hostId = "533cdfa7";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [];

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
