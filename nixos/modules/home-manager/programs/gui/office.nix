{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rnote
    joplin-desktop
    obsidian
    xournalpp

    inkscape
    gimp
    krita
    pixelorama
  ];
}
