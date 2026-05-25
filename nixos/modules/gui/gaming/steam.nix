{
  config,
  lib,
  pkgs,
  ...
}: {
  programs = { 
    steam = {
      enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
      protontricks.enable = true;
    };
    gamemode.enable = true;
  };

  users.users.dwaris.extraGroups = [
    "gamemode"
  ];
}
