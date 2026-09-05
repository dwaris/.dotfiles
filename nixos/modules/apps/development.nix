{pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    neovide
    vscode-fhs

    podman-tui
    podman-compose
  ];
}
