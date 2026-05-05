{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--password-store=gnome-libsecret"
        "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder"
        "--disable-features=UseChromeOSDirectVideoDecoder"
       ];
    })
  ];

  programs.chromium.enable = true;
  programs.firefox.enable = true;
}
