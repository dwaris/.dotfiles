{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    scalpel 
    foremost 
    testdisk 
    ddrescue
  ];
}

