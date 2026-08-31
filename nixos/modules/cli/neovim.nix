{
  pkgs,
  lib,
  ...
}: {
  programs.nix-ld.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.vim.defaultEditor = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    lazygit
    trash-cli
    sqlite

    # Nix Formatter & Language Server
    alejandra
    nixd
  ];
}
