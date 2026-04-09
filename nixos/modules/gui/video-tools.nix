{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    handbrake
    mkvtoolnix

    yt-dlp
    ffmpeg
  ];
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };
}
