{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    tmux
    stow
    fzf
    zoxide
    direnv
    starship
  ];
}
