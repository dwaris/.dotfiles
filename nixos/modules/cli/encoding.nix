{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    opusTools
    ffmpeg_7
  ];
}
