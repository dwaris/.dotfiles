{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        rnote
        joplin-desktop
        p3x-onenote
        xournalpp
    ];
}
