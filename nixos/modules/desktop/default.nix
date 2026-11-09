{
  pkgs,
  lib,
  ...
}: {
  services.fwupd.enable = true;
  services.orca.enable = false;
  services.speechd.enable = false;

  fonts.packages = with pkgs; [
    ibm-plex
    nerd-fonts.blex-mono
    nerd-fonts.symbols-only

    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  services.smartd = {
    autodetect = true;
    enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraLadspaPackages = [pkgs.rnnoise-plugin];
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.icu
      pkgs.libxcrypt-legacy
    ];
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
    settings = {
      cgroup_realtime_workaround = lib.mkForce false;
    };
  };

  security.pki.certificateFiles = [../../certs/root_ca.crt];

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
