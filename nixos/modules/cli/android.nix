{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.dwaris.extraGroups = ["adbusers"];

  environment.systemPackages = with pkgs; [
    android-tools
  ];
}
