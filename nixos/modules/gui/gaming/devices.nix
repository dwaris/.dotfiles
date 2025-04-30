{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    via
    piper
  ];
  services.udev.packages = with pkgs; [ via ];
  services.ratbagd.enable = true;
}
