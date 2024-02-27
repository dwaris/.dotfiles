{ config, pkgs, ... }: {
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    epiphany # web browser
    geary # email reader
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
 ]);

  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };

    desktopManager = {
      gnome = {
        enable = true;
      };
    };
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}
