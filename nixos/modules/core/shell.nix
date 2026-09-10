{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      mise
      stow
      fzf
      starship
      tmux
    ]
    ++ lib.optional (pkgs ? herdr) pkgs.herdr;

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
