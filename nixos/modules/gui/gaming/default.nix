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

  services.scx = lib.mkForce {
    scheduler = "scx_lavd";
    extraArgs = ["--performance"];
  };
}
