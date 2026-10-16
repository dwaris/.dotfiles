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
}
