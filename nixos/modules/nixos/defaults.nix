{ config, pkgs, ... }: {
imports = [
  ../../modules/nixos/user.nix
  ../../modules/nixos/locale.nix
  ../../modules/nixos/audio.nix
];
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the XWayland Fallback windowing system.
  programs.xwayland.enable = true;

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
  virtualisation.docker.enable = true;
  
  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "SourceCodePro" "FiraCode" ]; })
  ];

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
