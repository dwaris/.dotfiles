{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ghostty

    pi-coding-agent
    antigravity-cli

    neovide

    zed-editor-fhs
  ];
}
