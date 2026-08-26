{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unrar

    wl-clipboard
    kdePackages.filelight
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

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kwallet
    kwalletmanager
  ];

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = false;
}
