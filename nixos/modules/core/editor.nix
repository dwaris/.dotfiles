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

    # Nix Formatter & Language Server
    alejandra
    nixd
  ];
}
