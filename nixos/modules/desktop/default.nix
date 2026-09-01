{pkgs, ...}: {
  imports = [
    ../networking/networkmanager.nix
  ];

  environment.systemPackages = with pkgs; [
    appimage-run
  ];

  services.fwupd.enable = true;

  fonts.packages = with pkgs; [
    ibm-plex
    nerd-fonts.blex-mono

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

    source-code-pro
    nerd-fonts.sauce-code-pro
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
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.icu
      pkgs.libxcrypt-legacy
    ];
  };

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = "*";
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  security.pki.certificateFiles = [../../.certs/root_ca.crt];
}
