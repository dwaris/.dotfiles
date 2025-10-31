{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    easyeffects

    via
    piper
  ];
  services.udev.packages = with pkgs; [ via ];
  services.ratbagd.enable = true;
}
