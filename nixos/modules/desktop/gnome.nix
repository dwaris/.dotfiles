{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./default.nix
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnome-tweaks
    gnome-connections
    adw-gtk3
  ];
  # Enable the XWayland Fallback windowing system.
  programs.xwayland.enable = true;

  # Configure keymap in and Dispay Manager
  services = {
    avahi.enable = lib.mkForce false;
    orca.enable = lib.mkForce false;
    displayManager.gdm = {
      enable = true;
    };
    desktopManager.gnome.enable = true;
  };

  services.udev.packages = with pkgs; [gnome-settings-daemon];
}
