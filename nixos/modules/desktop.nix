{
  config,
  pkgs,
  ...
}: {
  boot.plymouth.enable = true;

  environment.systemPackages = with pkgs; [
    appimage-run
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.sauce-code-pro
    source-code-pro
  ];
  services.fwupd.enable = true;

  services.smartd = {
    autodetect = true;
    enable = true;
  };

  services.tuned = {
    enable = true;
    settings.dynamic_tuning = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.flatpak.enable = true;
  environment.sessionVariables.XDG_DATA_DIRS = ["/var/lib/flatpak/exports/share"];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.icu
      pkgs.libxcrypt-legacy
    ];
  };

  security.pki.certificateFiles = [../.certs/root_ca.crt];
}
