{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnome.gnome-tweaks
    wl-clipboard
  ];
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  # Enable the XWayland Fallback windowing system.
  programs.xwayland.enable = true;

  # Configure keymap in and Dispay Manager
  services.xserver = {
    enable = true;
    xkb = {
      layout = "eu";
    };
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager.gnome.enable = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}
