{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mise
    stow
    fzf
    starship
    tmux
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
