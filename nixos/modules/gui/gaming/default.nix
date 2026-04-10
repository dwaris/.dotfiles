{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./steam.nix
    ./launcher.nix
  ];

  fileSystems."/home/dwaris/Games" = {
    device = "zpool/games";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  services.scx.extraArgs = [
    "-m"
    "performance"
    "-w"
  ];
  programs.gpu-screen-recorder.enable = true;
  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk
  ];
}
