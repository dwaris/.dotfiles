{pkgs, ...}: {
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    neovim

    # Tooling-tier exception: Neovim compiles Tree-sitter parsers with GCC.
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
