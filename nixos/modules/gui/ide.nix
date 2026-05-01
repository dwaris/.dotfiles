{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ghostty
    gemini-cli
    neovide
    vscode-fhs
  ];
}
