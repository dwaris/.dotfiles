{ config, pkgs, ... }: {
imports = [
  ../../modules/nixos/user.nix
  ../../modules/nixos/locale.nix
];
  # Enable networking
  networking.networkmanager.enable = true;

  # Configure keymap in and Dispay Manager
  services.xserver = {
    xkb = {
      layout = "eu";
    };
    enable = true;
  };
  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = false;
  
  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
