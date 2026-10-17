{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./default.nix
  ];
  environment.systemPackages = with pkgs; [
    unrar
    proton-vpn

    wl-clipboard
    kdePackages.filelight
    kdePackages.keepsecret
    (catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["mauve"];
    })
    (catppuccin-kde.override {
      flavour = ["latte"];
      accents = ["mauve"];
    })
  ];

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
  };

  # Disable legacy KWallet in favor of oo7 Secret Service
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kwallet
    kwalletmanager
  ];

  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
  '';

  security.pam.services = {
    login.kwallet.enable = lib.mkForce false;
    kde.kwallet.enable = lib.mkForce false;
  };

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = false;

  # Workaround for NixOS/nixpkgs#363068:
  # Prevents libplasma/ksvg from scanning ~90 Nix store paths across XDG_DATA_DIRS
  # for the missing translucent/colors theme file on every UI/menu/systray interaction.
  systemd.user.tmpfiles.rules = [
    "d %h/.local/share/plasma/desktoptheme/default/translucent 0755 - - -"
    "L+ %h/.local/share/plasma/desktoptheme/default/translucent/colors - - - - ${pkgs.kdePackages.libplasma}/share/plasma/desktoptheme/breeze-dark/colors"
  ];

  # Deduplicate entries in XDG_DATA_DIRS to avoid redundant path traversal in Qt/KDE
  environment.extraInit = ''
    export XDG_DATA_DIRS="$(awk -v RS=: '{ if (!arr[$0]++) { printf("%s%s", !ln++ ? "" : ":", $0) }}' <<<"$XDG_DATA_DIRS")"
  '';
}
