{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    darktable
  ];
  programs.gphoto2.enable = true;
  users.users.dwaris.extraGroups = [
    "camera"
  ];
}
