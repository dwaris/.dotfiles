{pkgs, ...}: {
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    neovim

    gcc
    tree-sitter

    lazygit
    trash-cli
    sqlite

    # Search & picker dependencies
    fd
    ripgrep

    # Nix Formatter & Language Server
    alejandra
    nixd
  ];
}
