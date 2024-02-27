{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        firefox-bin
        (vivaldi.override {
            proprietaryCodecs = true;
            enableWidevine = true;
        })
    ];
}
