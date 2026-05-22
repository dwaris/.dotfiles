{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    darktable
    nomacs
  ];
  programs.gphoto2.enable = true;
  users.users.dwaris.extraGroups = [
    "camera"
  ];
}
