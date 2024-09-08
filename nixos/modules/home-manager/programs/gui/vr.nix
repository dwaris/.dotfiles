{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    alvr
    sidequest
  ];
}
