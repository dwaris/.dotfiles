{  pkgs,  config, ...}: {
    home.packages = with pkgs; [
        # archives
        zip
        unzip
        p7zip

        # utils
        ripgrep
        htop
        btop

        bottom
        fd
        neofetch

        # transfer
        rsync

	    neovim
    ];
}
