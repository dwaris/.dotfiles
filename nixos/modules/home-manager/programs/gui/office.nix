{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        rnote
        joplin-desktop
        xournalpp
    ];
}
