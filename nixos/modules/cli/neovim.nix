{pkgs, ...}: {
  programs.nix-ld.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    tree-sitter
    lazygit
    delta

    # Formatters
    alejandra
    stylua
    shfmt
    shellcheck

    # Language Servers (LSPs)
    lua-language-server
    gopls
    rust-analyzer
    pyright
    nixd
    typescript-language-server
    bash-language-server
    biome
    ruff
    texlab
    marksman
  ];
}


