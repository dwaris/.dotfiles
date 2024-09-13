{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    parallel
    opusTools

    ffmpeg_7
  ];
}
