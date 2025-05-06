{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    stow
    fzf
    zoxide
    direnv
    starship
  ];
}
