{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.shells = with pkgs; [ zsh ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kile

    pciutils
    clinfo
    glxinfo
    vulkan-tools
    wayland-utils
    aha
    wl-clipboard
    kdePackages.sddm-kcm
    kdePackages.filelight
    kdePackages.kasts
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "rosewater" ];
      winDecStyles = [ "classic" ];
    })
  ];
  # Configure keymap in and Dispay Manager
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
  };

  programs.ssh.startAgent = true;
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = false;
}
