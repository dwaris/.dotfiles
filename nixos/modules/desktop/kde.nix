{pkgs, ...}: {
  imports = [
    ./default.nix
  ];
  environment.systemPackages = with pkgs; [
    unrar
    proton-vpn

    libva-utils
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

  programs.partition-manager.enable = true;
  programs.kde-pim.enable = false;
}
