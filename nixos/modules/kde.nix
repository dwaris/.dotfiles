{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    kile

    pciutils
    clinfo
    mesa-demos
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
      winDecStyles = [ "modern" ];
    })
    (catppuccin-kde.override {
      flavour = [ "latte" ];
      accents = [ "rosewater" ];
      winDecStyles = [ "modern" ];
    })
  ];
  
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
  };

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = false;

  programs.dconf.enable = true;
}
