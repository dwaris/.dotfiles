{  pkgs,  config, ...}: {
    home.packages = with pkgs; [
        # archives
        zip
        unzip
        unrar
        p7zip

        # utils
        ripgrep
        htop
        btop

        bottom
        fd
        fastfetch

        # transfer
        rsync
    ];
}
