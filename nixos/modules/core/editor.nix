{pkgs, ...}: {
  programs.nix-ld.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
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
