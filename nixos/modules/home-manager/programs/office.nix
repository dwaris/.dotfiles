{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        nextcloud-client
        rnote
        joplin-desktop
        xournalpp
    ];
}
