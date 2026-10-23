{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mpv

    foliate

    plexamp
  ];
}
