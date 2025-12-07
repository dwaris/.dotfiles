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
    kdePackages.sddm-kcm
    kdePackages.filelight
    kdePackages.kasts
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "rosewater" ];
      winDecStyles = [ "classic" ];
    })
  ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
    krunner
    kwallet
    kwalletmanager
  ];
  
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
