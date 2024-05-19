{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        rnote
        joplin-desktop
        anytype
        xournalpp

        inkscape
        gimp
    ];
}
