{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    obsidian
    joplin-desktop

    anki-bin

    libreoffice-qt
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
  ];
}
