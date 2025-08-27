{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    handbrake
    mkvtoolnix
    obs-studio

    yt-dlp
    ffmpeg
  ];
}
