{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    stow
    fzf
    eza
    bat
    starship
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    zsh.enable = true;
    zoxide.enable = true;
  };

  environment.shells = with pkgs; [zsh];
}
