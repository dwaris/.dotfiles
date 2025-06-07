{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # archive
    zip
    unzip
    unrar
    p7zip

    # usage
    htop
    btop
    bottom

    # copy
    rsync

    # misc
    fastfetch
  ];
}
