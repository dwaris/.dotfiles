{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ghostty
    tmux
    wezterm

    gemini-cli

    neovide

    vscode-fhs
  ];
}
