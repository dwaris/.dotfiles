{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
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
