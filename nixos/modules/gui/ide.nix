{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wezterm
    vscode-fhs
  ];
}
