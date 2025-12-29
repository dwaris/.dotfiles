{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    obsidian

    anki-bin
  ];

  services.flatpak.packages = [
    "com.collaboraoffice.Office"
  ];
}
