{
  pkgs,
  lib,
  ...
}: {
  programs.nix-ld.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.vim.defaultEditor = lib.mkForce false;

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
