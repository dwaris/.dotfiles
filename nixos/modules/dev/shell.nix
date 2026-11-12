{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      bubblewrap
      mise
      stow
      fzf
      starship
      tmux
      zoxide
    ]
    ++ (lib.optional (pkgs ? herdr) pkgs.herdr);

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = false;
    };
    zsh = {
      enable = true;
      enableGlobalCompInit = false;
      promptInit = "";
    };
  };

  environment.shells = with pkgs; [zsh];
}
