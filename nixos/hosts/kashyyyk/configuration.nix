# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }: {
  imports =
    [ # Include the results of the hardware scan.
        ../../modules/system.nix
        ../../modules/gnome.nix
        ../../modules/nixos/fonts.nix

        # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [
    # https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X260#Thinkpad_X260
  "i915.enable_psr=0"
  ];

  networking.hostName = "kashyyyk"; # Define your hostname.
  networking.hostId = "f0cacf30";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zram-generator
  ];

  zramSwap.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.flatpak.enable = true;

  security.pki.certificates = [ "/etc/ssl/certs/root_ca.crt" ];

  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    vaapiVdpau
    libvdpau-va-gl
  ];

  system.stateVersion = "23.05"; # Did you read the comment?
}
