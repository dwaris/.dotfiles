{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    clang
    fd
    ripgrep

    bash-language-server

    marksman
    markdownlint-cli

    lua-language-server
    stylua

    nil
    nixfmt-rfc-style
    
    lazygit
    imagemagick
    ghostscript
  ];
}
