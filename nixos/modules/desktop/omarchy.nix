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
    adwaita-icon-theme
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
    hicolor-icon-theme
    hyprland
    hyprpaper
    hyprsunset
    inotify-tools
    jq
    kdePackages.breeze-icons
    lazygit
    libnotify
    libxkbcommon
    loupe
    nautilus
    pamixer
    papirus-icon-theme
    pavucontrol
    playerctl
    procps
    psmisc
    python3
    python3Packages.requests
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
    yaru-theme
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

      # Ensure theme state directory is user-writable on copy & bypass /etc browser writes
      substituteInPlace $out/share/omarchy/bin/omarchy-theme-set \
        --replace-fail 'flock 9' 'flock 9; chmod -R u+w "$HOME/.local/state/omarchy" 2>/dev/null || true'
      substituteInPlace $out/share/omarchy/bin/omarchy-theme-set-browser \
        --replace-fail '[[ -d $policy_dir ]]' '[[ -d $policy_dir && -w $policy_dir ]]'

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
