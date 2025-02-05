{
  config,
  pkgs,
  lib,
  ...
}:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kile

    pciutils
    clinfo
    glxinfo
    vulkan-tools
    wayland-utils
    aha
    wl-clipboard
    xwaylandvideobridge
    kdePackages.sddm-kcm
    kdePackages.filelight
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "rosewater" ];
      winDecStyles = [ "classic" ];
    })
  ];
  # Configure keymap in and Dispay Manager
  services = {
    xserver = {
      enable = true;
      xkb.layout = "eu";
    };
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kuserfeedback # nobody wants you here ok?
    discover
    oxygen
    elisa
  ];

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

  programs.ssh.startAgent = true;
  security.pam.services.sddm.kwallet.enable = true;
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-kde
    pkgs.xdg-desktop-portal-gtk
  ];

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.dconf.enable = true;
}
