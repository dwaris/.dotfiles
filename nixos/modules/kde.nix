{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kile

    unrar

    pciutils
    clinfo
    mesa-demos
    vulkan-tools
    wayland-utils
    aha
    wl-clipboard
    kdePackages.sddm-kcm
    kdePackages.filelight
    kdePackages.kasts
    (catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["rosewater"];
      winDecStyles = ["modern"];
    })
    (catppuccin-kde.override {
      flavour = ["latte"];
      accents = ["rosewater"];
      winDecStyles = ["modern"];
    })
  ];

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
  };

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = false;
}
