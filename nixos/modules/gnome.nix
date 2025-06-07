{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnome-tweaks
    wl-clipboard
  ];
  environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-contacts
      gnome-maps
      gnome-console
      simple-scan
      cheese # webcam tool
      snapshot
      gnome-music
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
  ];
  # Enable the XWayland Fallback windowing system.
  programs.xwayland.enable = true;

  # Configure keymap in and Dispay Manager
  services = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 42588 ];
  networking.firewall.allowedUDPPorts = [];

  services.openssh = {
    ports = [ 42588 ];
    allowSFTP = true; # Don't set this if you need sftp
    
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "dwaris" ];
    };
  };

  #xdg.portal.enable = true;
  #xdg.portal.xdgOpenUsePortal = true;
  #xdg.portal.extraPortals = [
  #  pkgs.xdg-desktop-portal-gtk
  #];

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.udev.packages = with pkgs; [ gnome-settings-daemon ];
}
