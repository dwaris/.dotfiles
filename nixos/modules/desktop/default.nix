{
  pkgs,
  lib,
  ...
}: {
  hardware.graphics.enable = true;

  fonts.packages = with pkgs; [
    ibm-plex
    nerd-fonts.blex-mono
    nerd-fonts.symbols-only

    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  services.fwupd.enable = true;
  services.smartd.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    extraLadspaPackages = [pkgs.rnnoise-plugin];
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
    settings = {
      cgroup_realtime_workaround = lib.mkForce false;
    };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.icu
        pkgs.libxcrypt-legacy
        pkgs.libgpg-error
      ];
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  security.pki.certificateFiles = [../../certs/root_ca.crt];

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
