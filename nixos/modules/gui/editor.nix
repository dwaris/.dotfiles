{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ghostty

    opencode
    neovide
    vscode-fhs
  ];
}
