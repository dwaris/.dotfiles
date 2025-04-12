{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ghostty
    kitty

    vscode-fhs
    code-cursor
  ];
}
