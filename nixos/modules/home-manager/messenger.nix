{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        element-desktop

        (pkgs.discord.override {
            withOpenASAR = true;
            withVencord = true;
        })
    ];
}
