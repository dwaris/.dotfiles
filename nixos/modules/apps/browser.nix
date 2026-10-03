{pkgs, ...}: let
  brave-pkg =
    pkgs.brave-origin
    or pkgs.unstable.brave-origin;
in {
  environment.systemPackages = with pkgs; [
    (brave-pkg.override {
      enableVideoAcceleration = true;
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs = [
        "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder"
        "--disable-features=UseChromeOSDirectVideoDecoder"
        "--password-store=gnome-libsecret"
      ];
    })
    firefox
    tor-browser
  ];
}
