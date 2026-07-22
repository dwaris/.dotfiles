{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ghostty

    opencode
    antigravity-cli

    neovide

    zed-editor-fhs
    vscode-fhs
  ];
}
