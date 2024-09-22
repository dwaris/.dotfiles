{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.steam = {
    enable = true;

    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
  };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
}
