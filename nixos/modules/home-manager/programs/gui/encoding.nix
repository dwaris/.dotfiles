{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mkvtoolnix
    obs-studio
  ];
}
