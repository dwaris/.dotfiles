{pkgs, lib, ...}: {
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 8;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.kernelParams = [
    "quiet"
    "nowatchdog"
  ]; 
  boot.plymouth.enable = true;
}
