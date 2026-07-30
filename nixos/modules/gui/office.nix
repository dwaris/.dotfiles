{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US

    anki-bin
  ];

  services.flatpak.packages = [
    "md.obsidian.Obsidian"
  ];
}
