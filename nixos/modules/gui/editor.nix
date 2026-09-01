{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ghostty

    neovide

    vscode-fhs 
  ];
}
