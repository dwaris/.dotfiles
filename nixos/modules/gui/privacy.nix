{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    proton-vpn
    proton-vpn-cli
    qbittorrent
  ];
  environment.sessionVariables.SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
}
