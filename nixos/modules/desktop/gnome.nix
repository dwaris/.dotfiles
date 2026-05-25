{ config, pkgs, lib, ... }:
{
  imports = [
    ../networking/networkmanager.nix
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnome-tweaks
    gnome-connections
    wl-clipboard
    adw-gtk3
  ];
  # Enable the XWayland Fallback windowing system.
  programs.xwayland.enable = true;

  # Configure keymap in and Dispay Manager
  services = {
    displayManager.gdm = {
      enable = true;
    };
    desktopManager.gnome.enable = true;
  };

  services.gnome.gnome-remote-desktop.enable = true; # 'true' does not make the unit start automatically at boot
  systemd.services.gnome-remote-desktop = {
    wantedBy = ["graphical.target"]; # for starting the unit automatically at boot
  };
  networking.firewall.allowedTCPPorts = [3389];

  services.orca.enable = false;

  services.udev.packages = with pkgs; [gnome-settings-daemon];
}
