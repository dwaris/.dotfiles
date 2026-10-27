{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mise
    stow
    fzf
    starship
    tmux
    zoxide
  ];

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
