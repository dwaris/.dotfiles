{ config, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    makemkv
  ];
  boot.kernelModules = [ "sg" ];
}
