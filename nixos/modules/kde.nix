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
    kdePackages.xwaylandvideobridge
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

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kuserfeedback # nobody wants you here ok?
    discover
    oxygen
    elisa
  ];

  programs.ssh.startAgent = true;
  security.pam.services.sddm.kwallet.enable = true;
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  xdg.portal.extraPortals = [
    pkgs.kdePackages.xdg-desktop-portal-kde
    pkgs.xdg-desktop-portal-gtk
  ];

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = false;

  programs.dconf.enable = true;
}
