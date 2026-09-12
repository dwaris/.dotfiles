{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (brave-origin.override {
      enableVideoAcceleration = true;
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
    firefox
    tor-browser
  ];
}
