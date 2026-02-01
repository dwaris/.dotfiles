{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    stow
    fzf
    starship
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
    zsh.enable = true;
  };

  environment.shells = with pkgs; [zsh];
}
