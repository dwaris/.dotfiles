{
  pkgs,
  lib,
  lanzaboote,
  ...
}: {
  imports = [
    lanzaboote.nixosModules.lanzaboote
    ./boot.nix
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
