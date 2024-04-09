{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        element-desktop
        telegram-desktop

        (pkgs.discord.override {
            withOpenASAR = true;
            withVencord = true;
        })
    ];
}
