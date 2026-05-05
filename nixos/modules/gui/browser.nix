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
        "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,Vulkan"
        "--disable-features=UseChromeOSDirectVideoDecoder"
       ];
    })
  ];

  programs.chromium.enable = true;
  programs.firefox.enable = true;
}
