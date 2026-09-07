{
  boot.loader.timeout = 0;
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 4;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.kernelParams = [
    "quiet"
  ];
  boot.plymouth.enable = true;
  boot.plymouth.theme = "tribar";
}
