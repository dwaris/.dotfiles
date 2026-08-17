{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (brave-origin.override {
      enableVideoAcceleration = true;
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
    firefox
  ];
}
