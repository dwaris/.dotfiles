{ config, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    tmux
    stow
    fzf
    zoxide
    direnv
    starship
  ];
}
