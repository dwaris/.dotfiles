{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../networking/networkmanager.nix
  ];

  environment.systemPackages = with pkgs; [
    wl-clipboard

    nomacs
    kdePackages.okular

    adw-gtk3
  ];
  programs.xwayland.enable = true;

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
