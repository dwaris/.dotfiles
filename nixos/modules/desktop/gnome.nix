{pkgs, ...}: {
  imports = [
    ./default.nix
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

  services.orca.enable = false;

  services.udev.packages = with pkgs; [gnome-settings-daemon];
}
