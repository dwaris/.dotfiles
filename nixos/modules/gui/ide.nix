{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wezterm
    neovide

    vscode-fhs
    alejandra
  ];
}
