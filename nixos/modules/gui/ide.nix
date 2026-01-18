{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ghostty
    tmux
    neovide

    vscode-fhs
    alejandra
  ];
}
