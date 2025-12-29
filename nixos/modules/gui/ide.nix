{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ghostty
    tmux

    vscode-fhs
    alejandra
  ];
}
