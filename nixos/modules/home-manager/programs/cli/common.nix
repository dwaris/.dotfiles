{  pkgs,  config, ...}: {
    home.packages = with pkgs; [
        # archives
        zip
        unzip
        p7zip

        # utils
        ripgrep
        htop

        bottom
        fd
        neofetch

        # transfer
        rsync
    ];

    programs = {
        btop.enable = true;
    };
}
