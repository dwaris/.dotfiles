{pkgs, ...}: {
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
    colord.enable = true;
  };

  programs.partition-manager.enable = true;

  # Workaround for NixOS/nixpkgs#363068:
  # Prevents libplasma/ksvg from scanning ~90 Nix store paths across XDG_DATA_DIRS
  # for the missing translucent/colors theme file on every UI/menu/systray interaction.
  systemd.user.tmpfiles.rules = [
    "d %h/.local/share/plasma/desktoptheme/default/translucent 0755 - - -"
    "L+ %h/.local/share/plasma/desktoptheme/default/translucent/colors - - - - ${pkgs.kdePackages.libplasma}/share/plasma/desktoptheme/breeze-dark/colors"
  ];
}
