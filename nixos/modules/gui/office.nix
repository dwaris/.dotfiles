{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    obsidian
    xournalpp

    anki-bin

    libreoffice
  ];
}
