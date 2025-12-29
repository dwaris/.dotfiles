{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    protonvpn-gui
    qbittorrent
    veracrypt
  ];
  environment.sessionVariables.SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
}
