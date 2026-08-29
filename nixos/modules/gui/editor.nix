{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ghostty

    antigravity-cli

    neovide

    vscode-fhs 
  ];
}
