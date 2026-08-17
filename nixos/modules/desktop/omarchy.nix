{
  pkgs,
  inputs,
  ...
}: let
  # Symlink `tte` (terminaltexteffects) as `ttfx` for Omarchy screensaver
  ttfx = pkgs.runCommand "ttfx" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.terminaltexteffects}/bin/tte $out/bin/ttfx
  '';

  # Runtime dependencies for Omarchy CLI, Quickshell & GUI applications
  deps = with pkgs; [
    bash
    brightnessctl
    btop
    cliphist
    coreutils
    desktop-file-utils
    evince
    fastfetch
    findutils
    ghostty
    glib.bin
    gpu-screen-recorder
    grim
    gtk3
    gum
    hyprland
    hyprpaper
    hyprsunset
    jq
    lazygit
    libnotify
    loupe
    nautilus
    pamixer
    pavucontrol
    playerctl
    procps
    psmisc
    quickshell
    slurp
    socat
    starship
    tesseract
    terminaltexteffects
    ttfx
    util-linux
    uwsm
    wl-clipboard
    xdg-terminal-exec
    xdg-utils
    zenity
  ];

  omarchyCli = pkgs.stdenv.mkDerivation {
    pname = "omarchy-cli";
    version = "4.0.0";
    src = inputs.omarchy-src;
    nativeBuildInputs = [pkgs.makeWrapper];
    installPhase = ''
      mkdir -p $out/bin $out/share/omarchy
      cp -r * $out/share/omarchy/

      for f in $out/share/omarchy/bin/*; do
        if [ -x "$f" ]; then
          makeWrapper "$f" "$out/bin/$(basename "$f")" \
            --set OMARCHY_PATH "$out/share/omarchy" \
            --prefix PATH : ${pkgs.lib.makeBinPath deps}
        fi
      done
    '';
  };
in {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  environment.systemPackages = [omarchyCli] ++ deps;
  environment.sessionVariables = {OMARCHY_PATH = "${omarchyCli}/share/omarchy";};

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    "${omarchyCli}/share/omarchy/default/fonts"
  ];

  security.polkit.enable = true;
  security.pam.services.omarchy-lock-password.text = ''
    #%PAM-1.0
    auth       required                    pam_faillock.so preauth silent deny=10 unlock_time=120
    auth       [success=1 default=bad]     pam_unix.so try_first_pass nullok
    auth       default=die                 pam_faillock.so authfail deny=10 unlock_time=120
    account    include                     system-local-login
  '';

  systemd.user.services.mako.enable = false;

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
    accounts-daemon.enable = true;
    gnome = {
      sushi.enable = true;
      localsearch.enable = true;
      glib-networking.enable = true;
    };
  };

  programs.dconf.enable = true;
}
