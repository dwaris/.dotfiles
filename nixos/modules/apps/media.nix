{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (mpv.override {youtubeSupport = false;})

    foliate

    plexamp
  ];
}
