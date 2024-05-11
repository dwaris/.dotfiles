{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        parallel
        ffmpeg_7
        opusTools
    ];
}
