{pkgs, ...}: {
  boot.kernelParams = [
    "quiet"
    "splash"
  ]; 
  boot.plymouth.enable = true;

  boot.loader.systemd-boot = {
    enable = false;
    configurationLimit = 10;
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
