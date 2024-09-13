{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    tmux
    neovim
    stow
    fzf
    zoxide
    direnv
    starship
  ];
}
