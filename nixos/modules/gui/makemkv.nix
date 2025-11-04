{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    makemkv
  ];
  boot.kernelModules = [ "sg" ];
}
