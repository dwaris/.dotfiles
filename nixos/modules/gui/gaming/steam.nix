{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  programs = { 
    steam = {
      enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
      protontricks.enable = true;
    };
    gamemode = {
      enable = true;
      settings = 
        {
          general = {
            renice = 10;
          };
          # Warning: GPU optimisations have the potential to damage hardware
          gpu = {
            apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 1;
            amd_performance_level = "high";
          };
        };
    };
    # completly broken
    # capSysNice doesn't work (permission error)
    # -e launch option doesn't work either
    #
    # gamescope = { 
    #   enable = true;
    #   capSysNice = true;
    # };
  };
  users.users.dwaris.extraGroups = [
    "gamemode"
  ];
}

