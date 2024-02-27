{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        parallel
        ffmpeg
        opusTools
    ];
}
