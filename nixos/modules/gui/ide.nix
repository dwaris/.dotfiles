{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ghostty
    tmux
    gemini-cli
    neovide

    vscode-fhs
  ];
}
